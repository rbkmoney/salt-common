{% set conf = salt['pillar.get']('carbon:cache:conf', {}) %}
# Managed by Salt
[cache]
#
# For FHS style directory structures, use:
#
STORAGE_DIR    = /var/lib/carbon/
CONF_DIR       = /etc/carbon/
LOG_DIR        = /var/log/carbon/
PID_DIR        = /run/
LOCAL_DATA_DIR = /var/lib/carbon/whisper/

# Specify the user to drop privileges to
# If this is blank carbon runs as the user that invokes it
# This user must have write access to the local data directory
USER = carbon

# Limit the size of the cache to avoid swapping or becoming CPU bound.
# Sorts and serving cache queries gets more expensive as the cache grows.
# Use the value "inf" (infinity) for an unlimited cache size.
MAX_CACHE_SIZE = {{ conf.get('max-cache-size', 'inf') }}

# Limits the number of whisper update_many() calls per second, which effectively
# means the number of write requests sent to the disk. This is intended to
# prevent over-utilizing the disk and thus starving the rest of the system.
# When the rate of required updates exceeds this, then carbon's caching will
# take effect and increase the overall throughput accordingly.
MAX_UPDATES_PER_SECOND = {{ conf.get('max-updates-per-second', 500) }}

# Softly limits the number of whisper files that get created each minute.
# Setting this value low (like at 50) is a good way to ensure your graphite
# system will not be adversely impacted when a bunch of new metrics are
# sent to it. The trade off is that it will take much longer for those metrics'
# database files to all get created and thus longer until the data becomes usable.
# Setting this value high (like "inf" for infinity) will cause graphite to create
# the files quickly but at the risk of slowing I/O down considerably for a while.
MAX_CREATES_PER_MINUTE = {{ conf.get('max-creates-per-minute', 50) }}

LINE_RECEIVER_INTERFACE = 127.0.0.1
LINE_RECEIVER_PORT = 2003

# Set this to True to enable the UDP listener. By default this is off
# because it is very common to run multiple carbon daemons and managing
# another (rarely used) port for every carbon instance is not fun.
ENABLE_UDP_LISTENER = True
UDP_RECEIVER_INTERFACE = 127.0.0.1
UDP_RECEIVER_PORT = 2003

PICKLE_RECEIVER_INTERFACE = 127.0.0.1
PICKLE_RECEIVER_PORT = 2004

# Per security concerns outlined in Bug #817247 the pickle receiver
# will use a more secure and slightly less efficient unpickler.
# Set this to True to revert to the old-fashioned insecure unpickler.
USE_INSECURE_UNPICKLER = False

CACHE_QUERY_INTERFACE = 127.0.0.1
CACHE_QUERY_PORT = 7002

# Set this to False to drop datapoints received after the cache
# reaches MAX_CACHE_SIZE. If this is True (the default) then sockets
# over which metrics are received will temporarily stop accepting
# data until the cache size falls below 95% MAX_CACHE_SIZE.
USE_FLOW_CONTROL = {{ conf.get('use-flow-control', 'True') }}

# By default, carbon-cache will log every whisper update. This can be excessive and
# degrade performance if logging on the same volume as the whisper data is stored.
LOG_UPDATES = False

# On some systems it is desirable for whisper to write synchronously.
# Set this option to True if you'd like to try this. Basically it will
# shift the onus of buffering writes from the kernel into carbon's cache.
WHISPER_AUTOFLUSH = {{ conf.get('whisper-autoflush', 'False') }}

# By default new Whisper files are created pre-allocated with the data region
# filled with zeros to prevent fragmentation and speed up contiguous reads and
# writes (which are common). Enabling this option will cause Whisper to create
# the file sparsely instead. Enabling this option may allow a large increase of
# MAX_CREATES_PER_MINUTE but may have longer term performance implications
# depending on the underlying storage configuration.
WHISPER_SPARSE_CREATE = {{ conf.get('whisper-sparse-create', 'False') }}

# Enabling this option will cause Whisper to lock each Whisper file it writes
# to with an exclusive lock (LOCK_EX, see: man 2 flock). This is useful when
# multiple carbon-cache daemons are writing to the same files
WHISPER_LOCK_WRITES = {{ conf.get('whisper-lock-writes', 'False') }}

# Set this to True to enable whitelisting and blacklisting of metrics in
# CONF_DIR/whitelist and CONF_DIR/blacklist. If the whitelist is missing or
# empty, all metrics will pass through
# USE_WHITELIST = False

# By default, carbon itself will log statistics (such as a count, 
# metricsReceived) with the top level prefix of 'carbon' at an interval of 60
# seconds. Set CARBON_METRIC_INTERVAL to 0 to disable instrumentation
CARBON_METRIC_PREFIX = carbon
CARBON_METRIC_INTERVAL = {{ conf.get('carbon-metric-interval', 60) }}

# Patterns for all of the metrics this machine will store. Read more at
# http://en.wikipedia.org/wiki/Advanced_Message_Queuing_Protocol#Bindings
#
# Example: store all sales, linux servers, and utilization metrics
# BIND_PATTERNS = sales.#, servers.linux.#, #.utilization
#
# Example: store everything
# BIND_PATTERNS = #
