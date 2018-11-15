# Managed by Salt
# Elasticsearch home directory
#ES_HOME=/usr/share/elasticsearch

# Elasticsearch Java path
#JAVA_HOME=

# Elasticsearch configuration directory
CONF_DIR="{{ conf_dir }}"

# Elasticsearch data directory
DATA_DIR="{{ data_dir }}"

# Elasticsearch logs directory
LOG_DIR="{{ log_dir }}"

# Additional Java OPTS
ES_JAVA_OPTS="{{ es_java_opts if es_java_opts is defined else '' }}"

ES_USER=elasticsearch
ES_GROUP=elasticsearch

# The number of seconds to wait before checking if Elasticsearch started successfully as a daemon process
ES_STARTUP_SLEEP_TIME={{ es_startup_sleep_time }}

# Specifies the maximum file descriptor number that can be opened by this process
# When using Systemd, this setting is ignored and the LimitNOFILE defined in
# /usr/lib/systemd/system/elasticsearch.service takes precedence
MAX_OPEN_FILES={{ l_nofile }}

# The maximum number of bytes of memory that may be locked into RAM
# Set to "unlimited" if you use the 'bootstrap.memory_lock: true' option
# in elasticsearch.yml.
# When using Systemd, the LimitMEMLOCK property must be set
# in /usr/lib/systemd/system/elasticsearch.service
MAX_LOCKED_MEMORY={{ l_memlock }}

# Maximum number of VMA (Virtual Memory Areas) a process can own
# When using Systemd, this setting is ignored and the 'vm.max_map_count'
# property is set at boot time in /usr/lib/sysctl.d/elasticsearch.conf
MAX_MAP_COUNT={{ max_map_count }}

MAX_THREADS={{ max_threads }}

rc_ulimit="-l $MAX_LOCKED_MEMORY -n $MAX_OPEN_FILES -u $MAX_THREADS"
