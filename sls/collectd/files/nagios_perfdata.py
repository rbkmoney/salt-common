# -*- coding: utf-8 -*-
# collectd Python plugin: Nagios perfdata → collectd metrics.
# See README.org for full documentation.

import collectd
import copy
import os
import re
import time

# Configuration defaults

SPOOL_DIR = '/var/lib/nagios/spool/graphios'
REPLACEMENT_CHAR = '_'
REVERSE_HOSTNAME = False
REPLACE_HOSTNAME_DOTS = False
USE_SERVICE_DESC = True
METRIC_BASE_PATH = 'nagios'
INTERVAL = 15              # seconds between read() calls
LOG_DETAILS = False         # verbose per-metric logging

# Helpers

# Characters invalid in collectd label parts
_INVALID_CHARS = re.compile(r'[~!$:;%^*()+={}[\]|\\/<>\s]')


def _sanitize(s):
    """Replace characters that are illegal in collectd identifiers."""
    return _INVALID_CHARS.sub(REPLACEMENT_CHAR, s)


def _parse_config_node(node):
    """Recursively flatten a collectd.Config tree into a dict."""
    d = {}
    for child in node.children:
        if child.values:
            d[child.key] = child.values[0]
        elif child.children:
            d.update(_parse_config_node(child))
    return d


class GraphiosMetric(object):
    """
    Mirrors the Graphios GraphiosMetric object.  One instance is created
    per perfdata line from Nagios, then copied for each individual metric
    inside the PERFDATA string.
    """

    def __init__(self):
        self.LABEL = ''
        self.VALUE = ''
        self.UOM = ''
        self.WARN = ''
        self.CRIT = ''
        self.MIN = ''
        self.MAX = ''
        self.DATATYPE = ''
        self.TIMET = ''
        self.HOSTNAME = ''
        self.SERVICEDESC = ''
        self.PERFDATA = ''
        self.SERVICECHECKCOMMAND = ''
        self.HOSTCHECKCOMMAND = ''
        self.HOSTSTATE = ''
        self.HOSTSTATETYPE = ''
        self.SERVICESTATE = ''
        self.SERVICESTATETYPE = ''
        # collectd equivalents of graphite prefix/postfix
        self.COLLECTDPREFIX = ''
        self.COLLECTDPOSTFIX = ''
        # backward-compat aliases
        self.GRAPHITEPREFIX = ''
        self.GRAPHITEPOSTFIX = ''
        # general
        self.METRICBASEPATH = METRIC_BASE_PATH
        self.VALID = False

    def _resolve_prefix(self):
        """Prefer COLLECTD* vars; fall back to GRAPHITE* vars."""
        if not self.COLLECTDPREFIX and self.GRAPHITEPREFIX:
            self.COLLECTDPREFIX = self.GRAPHITEPREFIX
        if not self.COLLECTDPOSTFIX and self.GRAPHITEPOSTFIX:
            self.COLLECTDPOSTFIX = self.GRAPHITEPOSTFIX

    def _adjust_hostname(self):
        if REVERSE_HOSTNAME:
            self.HOSTNAME = '.'.join(reversed(self.HOSTNAME.split('.')))
        if REPLACE_HOSTNAME_DOTS:
            self.HOSTNAME = self.HOSTNAME.replace('.', REPLACEMENT_CHAR)

    def validate(self):
        self._resolve_prefix()
        # strip stray quotes (Windows plugins)
        for attr in ('LABEL', 'VALUE'):
            v = getattr(self, attr)
            v = v.replace("'", '').replace('"', '')
            setattr(self, attr, v)
        self._adjust_hostname()

        if not self.TIMET or not self.PERFDATA or not self.HOSTNAME:
            return

        self.VALID = True


# Perfdata parsing (ported from Graphios)

def _get_metric_object(fields):
    """
    Parse one tab-delimited perfdata line (KEY::VALUE pairs) and return
    a GraphiosMetric if it is valid, else None.
    """
    mobj = GraphiosMetric()
    for field in fields:
        try:
            var_name, value = field.split('::', 1)
        except ValueError:
            collectd.warning('nagios_perfdata: cannot split field: %s' % field)
            return None

        value = value.replace('/', REPLACEMENT_CHAR)

        # Skip unresolved Nagios macros (they start with $_ and end with $)
        if re.match(r'^\$_', value):
            continue

        if 'PERFDATA' in var_name:
            mobj.PERFDATA = value
        else:
            value = re.sub(r'\s', r'\ ', value)
            # Map GRAPHITE* custom variable names to COLLECTD* equivalents
            var_name = var_name.replace('GRAPHITEPREFIX', 'COLLECTDPREFIX')
            var_name = var_name.replace('GRAPHITEPOSTFIX', 'COLLECTDPOSTFIX')
            if hasattr(mobj, var_name):
                setattr(mobj, var_name, value)

    mobj.validate()
    return mobj if mobj.VALID else None


def _parse_perfdata_string(perfdata):
    """
    Split a Nagios perfdata string into (label, value, uom, warn, crit,
    min, max) tuples.

    Perfdata format:
        'label'=value[UOM];[warn];[crit];[min];[max]
    """
    results = []
    for metric in perfdata.split():
        try:
            label, rest = metric.split('=', 1)
        except ValueError:
            continue

        parts = rest.split(';')
        raw_value = parts[0] if parts else ''

        # Separate numeric value from unit-of-measure suffix
        value = re.sub(r'[a-zA-Z%]', '', raw_value)
        uom = re.sub(r'[^a-zA-Z%]+', '', raw_value)

        warn = parts[1] if len(parts) > 1 and parts[1] else ''
        crit = parts[2] if len(parts) > 2 and parts[2] else ''
        vmin = parts[3] if len(parts) > 3 and parts[3] else ''
        vmax = parts[4] if len(parts) > 4 and parts[4] else ''

        if not value:
            continue

        results.append({
            'label': label,
            'value': value,
            'uom': uom,
            'warn': warn,
            'crit': crit,
            'min': vmin,
            'max': vmax,
        })
    return results


def _process_perfdata_file(filepath):
    """
    Read one rotated perfdata file and return a list of dicts
    ready for dispatch.
    """
    metrics = []
    try:
        with open(filepath, 'r') as fh:
            lines = fh.readlines()
    except (IOError, OSError) as exc:
        collectd.warning('nagios_perfdata: cannot read %s: %s' % (filepath, exc))
        return metrics

    for line in lines:
        line = line.strip()
        if not line.startswith('DATATYPE::'):
            continue

        fields = line.split('\t')
        mobj = _get_metric_object(fields)
        if not mobj:
            continue

        parsed = _parse_perfdata_string(mobj.PERFDATA)
        for p in parsed:
            m = copy.copy(mobj)
            m.LABEL = p['label']
            m.VALUE = p['value']
            m.UOM = p['uom']
            m.WARN = p['warn']
            m.CRIT = p['crit']
            m.MIN = p['min']
            m.MAX = p['max']
            metrics.append(m)

    return metrics


# Collectd callbacks

def _config(config_obj):
    """Handle <Module nagios_perfdata> … configuration."""
    global SPOOL_DIR, REPLACEMENT_CHAR, REVERSE_HOSTNAME
    global REPLACE_HOSTNAME_DOTS, USE_SERVICE_DESC, METRIC_BASE_PATH
    global INTERVAL, LOG_DETAILS

    cfg = _parse_config_node(config_obj)
    for key, val in cfg.items():
        low = key.lower()
        if low == 'spooldirectory':
            SPOOL_DIR = str(val)
        elif low == 'replacementchar':
            REPLACEMENT_CHAR = str(val)
        elif low == 'reversehostname':
            REVERSE_HOSTNAME = str(val).lower() in ('true', '1', 'yes')
        elif low == 'replacehostnamedots':
            REPLACE_HOSTNAME_DOTS = str(val).lower() in ('true', '1', 'yes')
        elif low == 'useservicedesc':
            USE_SERVICE_DESC = str(val).lower() in ('true', '1', 'yes')
        elif low == 'metricbasepath':
            METRIC_BASE_PATH = str(val)
        elif low == 'interval':
            INTERVAL = int(val)
        elif low == 'logdetails':
            LOG_DETAILS = str(val).lower() in ('true', '1', 'yes')

    collectd.info('nagios_perfdata: configured spool_dir=%s interval=%d' %
                  (SPOOL_DIR, INTERVAL))


def _init():
    collectd.info('nagios_perfdata: init, watching %s' % SPOOL_DIR)


def _read(data=None):
    """
    Called by collectd every INTERVAL seconds.  Scans the spool directory
    for rotated perfdata files, parses them, dispatches metrics, and
    removes the files.

    Active files still being written by Nagios (host-perfdata,
    service-perfdata) are skipped — same logic as Graphios.
    """
    if not os.path.isdir(SPOOL_DIR):
        collectd.warning('nagios_perfdata: spool dir %s does not exist' %
                         SPOOL_DIR)
        return

    total_metrics = 0
    total_files = 0

    try:
        entries = sorted(os.listdir(SPOOL_DIR))
    except (IOError, OSError) as exc:
        collectd.warning('nagios_perfdata: cannot list %s: %s' %
                         (SPOOL_DIR, exc))
        return

    for entry in entries:
        filepath = os.path.join(SPOOL_DIR, entry)

        # Skip the active files Nagios is currently writing to
        if entry in ('host-perfdata', 'service-perfdata'):
            continue

        # Skip dot-files / temp files
        if entry.startswith('_') or entry.startswith('.'):
            continue

        # Skip directories
        if os.path.isdir(filepath):
            continue

        # Skip empty files and remove them
        try:
            if os.stat(filepath).st_size == 0:
                os.remove(filepath)
                continue
        except OSError:
            continue

        metrics = _process_perfdata_file(filepath)
        total_files += 1

        for m in metrics:
            if _dispatch_metric(m):
                total_metrics += 1

        # Remove the processed file
        try:
            os.remove(filepath)
        except OSError as exc:
            collectd.warning('nagios_perfdata: failed to remove %s: %s' %
                             (filepath, exc))

    if total_files or LOG_DETAILS:
        collectd.info('nagios_perfdata: processed %d files, %d metrics' %
                      (total_files, total_metrics))


def _dispatch_metric(m):
    """
    Dispatch a single GraphiosMetric as a collectd.Values metric.

    Mapping:
        vl.host            <- HOSTNAME
        vl.plugin          <- COLLECTDPREFIX (fallback "nagios")
        vl.plugin_instance <- COLLECTDPOSTFIX if set,
                              else SERVICEDESC when use_service_desc=True,
                              else empty string
        vl.type_instance   <- LABEL (perfdata metric name)
        vl.values          <- [float(VALUE)]
        vl.time            <- TIMET (epoch)
    """
    try:
        value = float(m.VALUE)
    except (ValueError, TypeError):
        collectd.debug('nagios_perfdata: skipping non-numeric value: %s=%s' %
                       (m.LABEL, m.VALUE))
        return

    # Determine plugin_instance
    if m.COLLECTDPOSTFIX:
        plugin_instance = _sanitize(m.COLLECTDPOSTFIX)
    elif USE_SERVICE_DESC and m.SERVICEDESC:
        plugin_instance = _sanitize(m.SERVICEDESC)
    else:
        plugin_instance = ''

    vl = collectd.Values(type='gauge')
    vl.plugin = _sanitize(m.COLLECTDPREFIX) if m.COLLECTDPREFIX else 'nagios'
    vl.plugin_instance = plugin_instance
    vl.type_instance = _sanitize(m.LABEL)
    vl.host = _sanitize(m.HOSTNAME)
    vl.values = [value]

    try:
        ts = int(m.TIMET)
        if ts > 0:
            vl.time = ts
    except (ValueError, TypeError):
        pass

    if LOG_DETAILS:
        collectd.info('nagios_perfdata: dispatch host=%s plugin=%s '
                      'plugin_instance=%s type_instance=%s value=%s' %
                      (vl.host, vl.plugin, vl.plugin_instance,
                       vl.type_instance, vl.values[0]))

    vl.dispatch()
    return True


# Register callbacks

collectd.register_config(_config)
collectd.register_init(_init)
collectd.register_read(_read, INTERVAL)
