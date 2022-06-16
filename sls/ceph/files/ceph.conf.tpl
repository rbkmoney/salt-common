{% set ceph_conf = salt['pillar.get']('ceph:conf') -%}
{% macro true_false(o, key, default) %}
{{- 'true' if o.get(key, default) else 'false' -}}
{% endmacro %}
##
# This file defines cluster membership, the various locations
# that Ceph stores data, and any other runtime options.

# If a 'host' is defined for a daemon, the init.d start/stop script will
# verify that it matches the hostname (or else ignore it).  If it is
# not defined, it is assumed that the daemon is intended to start on
# the current host (e.g., in a setup with a startup.conf on each
# node).

## Metavariables
# $cluster    ; Expands to the Ceph Storage Cluster name. Useful
#             ; when running multiple Ceph Storage Clusters
#             ; on the same hardware.
#             ; Example: /etc/ceph/$cluster.keyring
#             ; (Default: ceph)
#
# $type       ; Expands to one of mds, osd, or mon, depending on
#             ; the type of the instant daemon.
#             ; Example: /var/lib/ceph/$type
#
# $id         ; Expands to the daemon identifier. For osd.0, this
#             ; would be 0; for mds.a, it would be a.
#             ; Example: /var/lib/ceph/$type/$cluster-$id
#
# $host       ; Expands to the host name of the instant daemon.
#
# $name       ; Expands to $type.$id.
#             ; Example: /var/run/ceph/$cluster-$name.asok

[global]
### http://ceph.com/docs/master/rados/configuration/general-config-ref/
fsid = {{ ceph_conf['fsid'] }}
public network = {{ ceph_conf['public-network'] }}
cluster network = {{ ceph_conf['cluster-network'] }}

# If set, when the Ceph Storage Cluster starts, Ceph sets the max open fds
# at the OS level (i.e., the max # of file descriptors).
# It helps prevents Ceph OSD Daemons from running out of file descriptors.
# Type: 64-bit Integer (optional)
# (Default: 0)
max open files = {{ ceph_conf.get('max-open-files', 131072) }}

{% set ceph_auth = ceph_conf.get('auth', {}) %}
# If enabled, the Ceph Storage Cluster daemons (i.e., ceph-mon, ceph-osd,
# and ceph-mds) must authenticate with each other.
auth cluster required = {{ ceph_auth.get('cluster-required', 'cephx') }}

# If enabled, the Ceph Storage Cluster daemons require Ceph Clients to
# authenticate with the Ceph Storage Cluster in order to access Ceph
# services.
auth service required = {{ ceph_auth.get('service-required', 'cephx') }}

# If enabled, the Ceph Client requires the Ceph Storage Cluster to
# authenticate with the Ceph Client.
auth client required = {{ ceph_auth.get('client-required', 'cephx') }}

auth allow insecure global id reclaim = {{ true_false(ceph_auth, 'allow-insecure-global-id-reclaim', False) }}

{% set ceph_cephx = ceph_conf.get('cephx', {}) %}
# If set to true, Ceph requires signatures on all message traffic between
# the Ceph Client and the Ceph Storage Cluster, and between daemons
# comprising the Ceph Storage Cluster.
cephx require signatures = {{ true_false(ceph_cephx, 'require-signatures', False) }}

# kernel RBD client do not support authentication yet:
cephx cluster require signatures = {{ true_false(ceph_cephx, 'cluster-require-signatures', True) }}
cephx service require signatures = {{ true_false(ceph_cephx, 'service-require-signatures', False) }}

# The location of the logging file for your cluster.
log file = /var/log/ceph/$cluster-$name.log

# Determines if logging messages should appear in syslog.
log to syslog = {{ true_false(ceph_conf, 'log-to-syslog', True) }}
ms bind ipv6 = {{ true_false(ceph_conf, 'ms-bind-ipv6', True) }}
ms bind ipv4 = {{ true_false(ceph_conf, 'ms-bind-ipv4', False) }}

{% set ceph_mon = ceph_conf.get('mon', {}) %}
{% set ceph_mon_clock = ceph_mon.get('clock', {}) %}
{% set ceph_mon_osd = ceph_mon.get('osd', {}) %}
{% set ceph_mon_debug = ceph_mon.get('debug', False) %}

[mon]
{% if 'initial-members' in ceph_mon %}
# The IDs of initial monitors in a cluster during startup.
mon initial members = {{ ceph_mon['initial-members'] }}
{% endif %}

# The clock drift in seconds allowed between monitors.
mon clock drift allowed = {{ ceph_mon_clock.get('drift-allowed', '.050') }}
# Exponential backoff for clock drift warnings
mon clock drift warn backoff = {{ ceph_mon_clock.get('drift-warn-backoff', '5') }}

# The percentage of disk space used before an OSD is considered full/nearfull.
mon osd full ratio = {{ ceph_mon_osd.get('full-ratio', '.95') }}
mon osd nearfull ratio = {{ ceph_mon_osd.get('nearfull-ratio', '.90') }}
# The number of seconds Ceph waits before marking a Ceph OSD "down" and "out"
mon osd down out interval  = {{ ceph_mon_osd.get('down-out-interval', 300) }}
# The grace period in seconds before declaring unresponsive Ceph OSD down
mon osd report timeout = {{ ceph_mon_osd.get('report-timeout', 900) }}
mon osd allow primary affinity = {{ true_false(ceph_mon_osd, 'allow-primary-affinity', True) }}

# TODO: Extra configuration options

{% if ceph_mon_debug %}
debug ms = {{ ceph_mon_debug.get('ms', 1) }}
debug mon = {{ ceph_mon_debug.get('mon', 20) }}
debug paxos = {{ ceph_mon_debug.get('paxos', 20) }}
debug auth = {{ ceph_mon_debug.get('auth', 20) }}
{% endif %}

{% for id,data in ceph_conf['mon-table'].items() %}
[mon.{{ id }}]
  host = {{ data['host'] }}
  mon addr = {{ data['addr'] }}
  {% for k,v in data.get('extra', {}).items() %}
  {{ k }} = {{ v }}
  {% endfor %}
{% endfor %}

{% set ceph_osd = ceph_conf.get('osd', {}) %}
{% set ceph_osd_filestore = ceph_osd.get('filestore', {}) %}
{% set ceph_osd_bluestore = ceph_osd.get('bluestore', {}) %}
{% set ceph_osd_debug = ceph_osd.get('debug', False) %}
[osd]
# The number of active recovery requests per OSD at one time.
# More requests will accelerate recovery, but the requests
# places an increased load on the cluster.
osd recovery max active = {{ ceph_osd.get('recovery-max-active', 1) }}

# The maximum number of backfills allowed to or from a single OSD.
osd max backfills = {{ ceph_osd.get('max-backfills', 1) }}

# The maximum number of simultaneous scrub operations for a Ceph OSD Daemon.
osd max scrubs = {{ ceph_osd.get('max-scrubs', 1) }}

# Check log files for corruption. Can be computationally expensive.
osd check for log corruption = {{ true_false(ceph_osd, 'check-for-log-corruption', False) }}

# By default OSDs update their details (location, weight and root) on the CRUSH map during startup
osd crush update on start = {{ true_false(ceph_osd, 'crush-update-on-start', True) }}

# The size of the journal in megabytes.
osd journal size = {{ ceph_osd.get('journal-size', 10240) }}

# The number of threads to service Ceph OSD Daemon Operations. Set to 0 to disable it.
# Increasing the number may increase the request processing rate.
osd op threads = {{ ceph_osd.get('op-threads', 4) }}

# An operation becomes complaint worthy after the specified number of seconds have elapsed
osd op complaint time = {{ ceph_osd.get('op-complaint-time', 30) }}

# osdmap cache size
# Set it higher if you encounter slow ops and cpu hungry OSDs hanging up
# https://tracker.ceph.com/issues/44184#note-17
osd map cache size = {{ ceph_osd.get('map-cache-size', 5000) }}

{% for key in ('recovery-priority', 'recovery-op-priority'
'min-pg-log-entries', 'max-pg-log-entries', 'pg-log-dups-tracked',
'max-pgls', 'max-pg-per-osd-hard-ratio') %}
{% if key in ceph_osd %}
osd {{ key.replace('-', ' ') }} = {{ ceph_osd[key] }}
{% endif %}
{% endfor %}

{% if ceph_osd_filestore.get('enable', False) %}
## Filestore

# The maximum interval in seconds for synchronizing the filestore.
filestore max sync interval = {{ ceph_osd_filestore.get('max-sync-interval', 5) }}

# Enables the filestore flusher.
filestore flusher = {{ true_false(ceph_osd_filestore, 'flusher', False) }}
filestore fiemap = {{ true_false(ceph_osd_filestore, 'fiemap', True) }}
filestore seek data hole = {{ true_false(ceph_osd_filestore, 'seek-data-hole', True) }}

# Defines the maximum number of in progress operations the file store
# accepts before blocking on queuing new operations.
filestore queue max ops = {{ ceph_osd_filestore.get('queue-max-ops', 500) }}

## Filestore and OSD settings can be tweak to achieve better performance
# Min number of files in a subdir before merging into parent
# NOTE: A negative value means to disable subdir merging
filestore merge threshold = {{ ceph_osd_filestore.get('merge-threshold', 10) }}

# filestore_split_multiple * abs(filestore_merge_threshold) * 16 is the maximum number
# of files in a subdirectory before splitting into child directories.
filestore split multiple = {{ ceph_osd_filestore.get('split-multiple', 4) }}

# The number of filesystem operation threads that execute in parallel.
filestore op threads = {{ ceph_osd_filestore.get('op-threads', 4) }}
{% endif %}

{% if ceph_osd_bluestore.get('enable', True) %}
## Bluestore
{% set bs_cache_autotune = ceph_osd_bluestore.get('cache-autotune', True) %}
bluestore cache autotune = {{ 'true' if bs_cache_autotune else 'false' }}

# Autotune
# The chunk size in bytes to allocate to caches when cache autotune is enabled.
bluestore cache autotune chunk size = {{ ceph_osd_bluestore.get('cache-autotune-chunk-size', 33554432) }}
# The number of seconds to wait between rebalances when cache autotune is enabled.
bluestore cache autotune interval = {{ ceph_osd_bluestore.get('cache-autotune-interval', 5) }}
# Try to keep this many bytes mapped in memory.
# Note: This may not exactly match the RSS memory usage of the process.
osd memory target = {{ ceph_osd.get('memory-target', 1073741824) }}
# Minimum amount of memory in bytes the OSD will need.
osd memory base = {{ ceph_osd.get('memory-base', 805306368) }}
# Estimate the percent of memory fragmentation.
osd memory expected fragmentation = {{ ceph_osd.get('memory-expected-fragmentation', 0.15) }}
# Set the minimum amount of memory used for caches.
osd memory cache min = {{ ceph_osd.get('memory-cache-min', 134217728) }}
# wait this many seconds between resizing caches.
osd memory cache resize interval = {{ ceph_osd.get('memory-cache-resize-interval', 1) }}

# Manual cache sizes
# The default amount of memory BlueStore will use for its cache when backed by an HDD.
bluestore cache size hdd = {{ ceph_osd_bluestore.get('cache-size-hdd', 1073741824) }}
# The default amount of memory BlueStore will use for its cache when backed by an SSD.
bluestore cache size ssd = {{ ceph_osd_bluestore.get('cache-size-ssd', 1073741824) }}
# The ratio of cache devoted to metadata.
bluestore cache meta ratio = {{ ceph_osd_bluestore.get('cache-meta-ratio', 0.1) }}
# The ratio of cache devoted to key/value data (rocksdb).
bluestore cache kv ratio = {{ ceph_osd_bluestore.get('cache-kv-ratio', 0.5) }}
# The maximum amount of cache devoted to key/value data (rocksdb).
bluestore cache kv max = {{ ceph_osd_bluestore.get('cache-kv-max', 536870912) }}
{% endif %}

{% for id,data in ceph_conf.get('osd-table', {}).items() %}
[osd.{{ id }}]
  {% for k,v in data.items() %}
  {{ k }} = {{ v }}
  {% endfor %}
{% endfor %}

{% set ceph_client = ceph_conf.get('client', {}) %}
{% set ceph_client_cache = ceph_client.get('cache', {}) %}
[client]

# Enable caching for RADOS Block Device (RBD).
rbd cache = {{ true_false(ceph_client_cache, 'enabled', True) }}
{% if ceph_client_cache.get('enabled', True) %}
# The RBD cache size in bytes.
rbd cache size = {{ ceph_client_cache.get('size', 33554432) }}

# The dirty limit in bytes at which the cache triggers write-back.
rbd cache max dirty = {{ ceph_client_cache.get('max-dirty', 25165824) }}

# The dirty target before the cache begins writing data to the data storage.
rbd cache target dirty = {{ ceph_client_cache.get('max-dirty', 16777216) }}

# The number of seconds dirty data is in the cache before writeback starts.
rbd cache max dirty age = {{ ceph_client_cache.get('max-dirty-age', 1.0) }}

# Start out in write-through mode, and switch to write-back after the
# first flush request is received.
rbd cache writethrough until flush = true
{% endif %}

{% for id,data in ceph_conf.get('client-table', {}).items() %}
[client.{{ id }}]
  {% for k,v in data.items() %}
  {{ k }} = {{ v }}
  {% endfor %}
{% endfor %}
