{% set ceph_conf = salt['pillar.get']('ceph:conf') -%}
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
auth cluster required = {{ ceph_auth.get('cluster-required', 'none') }}

# If enabled, the Ceph Storage Cluster daemons require Ceph Clients to
# authenticate with the Ceph Storage Cluster in order to access Ceph
# services.
auth service required = {{ ceph_auth.get('service-required', 'none') }}

# If enabled, the Ceph Client requires the Ceph Storage Cluster to
# authenticate with the Ceph Client.
auth client required = {{ ceph_auth.get('client-required', 'none') }}

{% set ceph_cephx = ceph_conf.get('cephx', {}) %}
# If set to true, Ceph requires signatures on all message traffic between
# the Ceph Client and the Ceph Storage Cluster, and between daemons
# comprising the Ceph Storage Cluster.
cephx require signatures = {{ 'true' if ceph_cephx.get('require-signatures', False) else 'false' }}

# kernel RBD client do not support authentication yet:
cephx cluster require signatures = {{ 'true' if ceph_cephx.get('cluster-require-signatures', True) else 'false' }}
cephx service require signatures = {{ 'true' if ceph_cephx.get('service-require-signatures', False) else 'false' }}

# The path to the keyring file.
keyring = /etc/ceph/$cluster.keyring

# The location of the logging file for your cluster.
log file = /var/log/ceph/$cluster-$name.log

# Determines if logging messages should appear in syslog.
log to syslog = {{ 'true' if ceph_conf.get('log-to-syslog', True) else 'false' }}
ms bind ipv6 = true

{% set ceph_mon = ceph_conf.get('mon', False) %}
{% if ceph_mon %}
[mon]
{% if 'initial-members' in ceph_mon %}
# The IDs of initial monitors in a cluster during startup.
mon initial members = {{ ceph_mon['initial-members'] }}
{% endif %}
{% set ceph_mon_clock = ceph_mon.get('clock', False) %}
{% if ceph_mon_clock %}
# The clock drift in seconds allowed between monitors.
mon clock drift allowed = {{ ceph_mon_clock.get('drift-allowed', '.050') }}
# Exponential backoff for clock drift warnings
mon clock drift warn backoff = {{ ceph_mon_clock.get('drift-warn-backoff', '5') }}
{% endif %}

{% set ceph_mon_osd = ceph_mon.get('osd', False) %}
{% if ceph_mon_osd %}
# The percentage of disk space used before an OSD is considered full/nearfull.
mon osd full ratio = {{ ceph_mon_osd.get('full-ratio', '.95') }}
mon osd nearfull ratio = {{ ceph_mon_osd.get('nearfull-ratio', '.90') }}
# The number of seconds Ceph waits before marking a Ceph OSD "down" and "out"
mon osd down out interval  = {{ ceph_mon_osd.get('down-out-interval', 300) }}
# The grace period in seconds before declaring unresponsive Ceph OSD down
mon osd report timeout = {{ ceph_mon_osd.get('report-timeout', 900) }}
mon osd allow primary affinity = {{ 'true' if ceph_mon_osd.get('allow-primary-affinity', True) else 'false' }}
{% endif %}

{% set ceph_mon_debug = ceph_mon.get('debug', False) %}
{% if ceph_mon_debug %}
debug ms = {{ ceph_mon_debug.get('ms', 1) }}
debug mon = {{ ceph_mon_debug.get('mon', 20) }}
debug paxos = {{ ceph_mon_debug.get('paxos', 20) }}
debug auth = {{ ceph_mon_debug.get('auth', 20) }}
{% endif %}
{% endif %}

{% for id,data in ceph_conf['mon-table'].items() %}
[mon.{{ id }}]
  host = {{ data['host'] }}
  mon addr = {{ data['addr'] }}
  {% for k,v in data.get('extra', {}).items() %}
  {{ k }} = {{ v }}
  {% endfor %}
{% endfor %}

{% set ceph_osd = ceph_conf.get('osd', False) %}
{% if ceph_osd %}
[osd]
# The number of active recovery requests per OSD at one time.
# More requests will accelerate recovery, but the requests
# places an increased load on the cluster.
osd recovery max active = {{ ceph_osd.get('recovery-max-active', 1) }}

# The maximum number of backfills allowed to or from a single OSD.
osd max backfills = {{ ceph_osd.get('max-backfills', 1) }}

# The maximum number of simultaneous scrub operations for a Ceph OSD Daemon.
osd max scrubs = {{ ceph_osd.get('max-scrubs', 1) }}

osd mkfs type = xfs
osd mkfs options xfs = {{ ceph_osd.get('mkfs-options', '-f') }}
osd mount options xfs  = {{ ceph_osd.get('mount-options', 'rw,noatime,logbsize=256k') }}

# Check log files for corruption. Can be computationally expensive.
osd check for log corruption = {{ 'true' if ceph_osd.get('check-for-log-corruption', False) else 'false' }}

# The size of the journal in megabytes.
osd journal size = {{ ceph_osd.get('journal-size', 10240) }}

# Enables direct i/o to the journal.
journal dio = true

{% set ceph_osd_debug = ceph_osd.get('debug', False) %}
{% if ceph_osd_debug %}
debug ms = {{ ceph_osd_debug.get('ms', 1) }}
debug osd = {{ ceph_osd_debug.get('osd', 20) }}
debug filestor = {{ ceph_osd_debug.get('filestore', 20) }}
debug journal = {{ ceph_osd_debug.get('journal', 20) }}
{% endif %}

{% set ceph_osd_filestore = ceph_osd.get('filestore', False) %}
{% if ceph_osd_filestore %}
# The maximum interval in seconds for synchronizing the filestore.
filestore max sync interval = {{ ceph_osd_filestore.get('max-sync-interval', 5) }}

# Enables the filestore flusher.
filestore flusher = {{ 'true' if ceph_osd_filestore.get('flusher', False) else 'false' }}
filestore fiemap = {{ 'true' if ceph_osd_filestore.get('fiemap', True) else 'false' }}
filestore seek data hole = {{ 'true' if ceph_osd_filestore.get('seek-data-hole', True) else 'false' }}

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
# The number of threads to service Ceph OSD Daemon Operations. Set to 0 to disable it.
# Increasing the number may increase the request processing rate.
osd op threads = {{ ceph_osd.get('op-threads', 4) }}

# By default OSDs update their details (location, weight and root) on the CRUSH map during startup
osd crush update on start = {{ 'true' if ceph_osd.get('crush-update-on-start', True) else 'false' }}
{% endif %}

{% for id,data in ceph_conf.get('osd-table', {}).items() %}
[osd.{{ id }}]
  {% for k,v in data.items() %}
  {{ k }} = {{ v }}
  {% endfor %}
{% endfor %}

{% set ceph_client = ceph_conf.get('client', False) %}
{% if ceph_client %}
[client]

{% set ceph_client_cache = ceph_client.get('cache', False) %}
{% if ceph_client_cache %}
# Enable caching for RADOS Block Device (RBD).
rbd cache = {{ 'true' if ceph_client.get('enabled', True) else 'false' }}
{% if ceph_client.get('enabled', True) %}
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
{% endif %}
{% endif %}

{% for id,data in ceph_conf.get('client-table', {}).items() %}
[client.{{ id }}]
  {% for k,v in data.items() %}
  {{ k }} = {{ v }}
  {% endfor %}
{% endfor %}
