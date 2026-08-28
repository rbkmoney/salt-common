;; -*- mode: conf -*-
{% set conf = salt['pillar.get']("pgbouncer", {}) %}
[pgbouncer]
pidfile = /run/postgresql/pgbouncer.pid
; IP address or * which means all IP-s
listen_addr = {{ conf.get("listen-addr", "*") }}
listen_port = {{ conf.get("listen-port", "6432") }}
; unix socket is also used for -R.
unix_socket_dir = {{ conf.get("unix-socket-dir", "/run/postgresql") }}
unix_socket_mode = {{ conf.get("unix-socket-mode", "0770") }}
unix_socket_group = {{ conf.get("unix-socket-group", "postgres") }}

;;; Authentication settings
auth_type = {{ conf.get('auth-type', 'hba') }}
auth_file = /etc/pgbouncer/userlist.txt
auth_hba_file = /etc/pgbouncer/pg_hba.conf
;; Users allowed into database 'pgbouncer'
; comma-separated list of users, who are allowed to change settings
admin_users = {{ conf.get('admin-users', 'postgres, pgbouncer') }}
; comma-separated list of users who are just allowed to use SHOW command
stats_users = {{ conf.get('stats-users', 'stats') }}

;;; Logging
logfile = /var/log/postgresql/pgbouncer.log
;; Syslog settings
syslog = {{ conf.get('syslog', '0') }}
syslog_facility = {{ conf.get('syslog-facility', 'daemon') }}
syslog_ident = {{ conf.get('syslog-ident', 'pgbouncer') }}
; Logging verbosity.  Same as -v switch on command line.
verbose = {{ conf.get('verbose', '0') }}
; log if client connects or server connection is made
log_connections = {{ conf.get('log-connections', '0') }}
; log if and why connection was closed
log_disconnections = {{ conf.get('log-disconnections', '0') }}
; log error messages pooler sends to clients
log_pooler_errors = {{ conf.get('log-pooler-errors', '0') }}
; Period for writing aggregated stats into log.
stats_period = {{ conf.get('stats-period', '0') }}

;;; Pooler personality questions
; When server connection is released back to pool:
;   session      - after client disconnects
;   transaction  - after transaction finishes
;   statement    - after statement finishes
pool_mode = {{ conf.get('pool-mode', 'session') }}
; If off, then server connections are reused in LIFO manner
;server_round_robin = 0
; Query for cleaning connection immediately after releasing from client.
; No need to put ROLLBACK here, pgbouncer does not reuse connections
; where transaction is left open.
; Query for 8.3+:
;   DISCARD ALL;
; Empty if transaction pooling is in use.
server_reset_query = {{ conf.get('server-reset-query', 'DISCARD ALL;') }}

; Whether server_reset_query should run in all pooling modes.
; If it is off, server_reset_query is used only for session-pooling.
server_reset_query_always = {{ conf.get('server-reset-query-always', '0') }}

; Comma-separated list of parameters to ignore when given
; in startup packet.  Newer JDBC versions require the
; extra_float_digits here.

ignore_startup_parameters = {{ conf.get('ignore-startup-parameters', 'extra_float_digits') }}

; When taking idle server into use, this query is ran first.
;   SELECT 1
server_check_query = {{ conf.get('server-check-query', 'SELECT 1') }}

; If server was used more recently that this many seconds ago,
; skip the check query.  Value 0 may or may not run in immediately.
server_check_delay = {{ conf.get('server-check-delay', '30') }}

;; Use <appname - host> as application_name on server.
application_name_add_host = 1

;;; Connection limits
; total number of clients that can connect
max_client_conn = {{ conf.get('max-client-conn', '1000') }}
; default pool size.  20 is good number when transaction pooling
; is in use, in session pooling it needs to be the number of
; max clients you want to handle at any moment
default_pool_size = {{ conf.get('default-pool-size', '20') }}
;; Minimum number of server connections to keep in pool.
min_pool_size = {{ conf.get('min-pool-size', '5') }}
;; Minimum number of server connections to keep in pool.
min_pool_size = {{ conf.get('min-pool-size', '5') }}
; if a clients needs to wait more than this many seconds, use reserve pool
reserve_pool_timeout = {{ conf.get('reserve-pool-timeout', '1') }}
; how many total connections to a single database to allow from all pools
max_db_connections = {{ conf.get('max-db-connections', '50') }}
; how many total connections from a single user to allow from all pools
max_user_connections = {{ conf.get('max-user-connections', '50') }}

;;; Timeouts
;; Close server connection if its been connected longer.
server_lifetime = {{ conf.get('server-lifetime', '14400') }}
;; Close server connection if its not been used in this time.
;; Allows to clean unnecessary connections from pool after peak.
server_idle_timeout = {{ conf.get('server-idle-timeout', '60') }}
;; Cancel connection attempt if server does not answer takes longer.
server_connect_timeout = {{ conf.get('server-connect-timeout', '5') }}
;; If server login failed (server_connect_timeout or auth failure)
;; then wait this many second.
server_login_retry = {{ conf.get('server-login-retry', '15') }}
;; Dangerous.  Server connection is closed if query does not return
;; in this time.  Should be used to survive network problems,
;; _not_ as statement_timeout. (default: 0)
query_timeout = {{ conf.get('query_timeout', '0') }}
;; Dangerous.  Client connection is closed if the query is not assigned
;; to a server in this time.  Should be used to limit the number of queued
;; queries in case of a database or network failure. (default: 120)
query_wait_timeout = {{ conf.get('query_wait_timeout', '120') }}
;; Dangerous.  Client connection is closed if no activity in this time.
;; Should be used to survive network problems. (default: 0)
client_idle_timeout = {{ conf.get('client-idle-timeout', '0') }}
;; Disconnect clients who have not managed to log in after connecting
;; in this many seconds.
client_login_timeout = {{ conf.get('client-login-timeout', '60') }}
;; Clean automatically created database entries (via "*") if they
;; stay unused in this many seconds.
autodb_idle_timeout = {{ conf.get('autodb-idle-timeout', '3600') }}
;; How long SUSPEND/-R waits for buffer flush before closing connection.
suspend_timeout = {{ conf.get('suspend-timeout', '10') }}
;; Close connections which are in "IDLE in transaction" state longer than
;; this many seconds.
idle_transaction_timeout = {{ conf.get('idle-transaction-timeout', '0') }}

; Comma-separated list of parameters to ignore when given
; in startup packet.  Newer JDBC versions require the
; extra_float_digits here.
ignore_startup_parameters = {{ conf.get('ignore-startup-parameters', 'extra_float_digits') }}

;;; Low-level tuning options
;; buffer for streaming packets
pkt_buf = {{ conf.get('pkt-buf', '64000') }}
;; man 2 listen
listen_backlog = {{ conf.get('listen-backlog', '1024') }}
;; Max number pkt_buf to process in one event loop.
sbuf_loopcnt = {{ conf.get('subf-loopcnt', '5') }}
;; Maximum Postgres protocol packet size.
max_packet_size = {{ conf.get('max-packet-size', '2147483647') }}

;; networking options, for info: man 7 tcp
;; Linux: notify program about new connection only if there
;; is also data received. (Seconds to wait.)
;; On Linux the default is 45, on other OS'es 0.
tcp_defer_accept = {{ conf.get('tcp-defer-accept', '45') }}
;; In-kernel buffer size (Linux default: 4096)
tcp_socket_buffer = {{ conf.get('tcp-socket-buffer', '2097152') }}
;; whether tcp keepalive should be turned on (0/1)
tcp_keepalive = {{ conf.get('tcp-keepalive', '1') }}
;; following options are Linux-specific.
;; they also require tcp_keepalive=1
;; count of keepalive packets
tcp_keepcnt = {{ conf.get('tcp-keepcnt', '5') }}
;; how long the connection can be idle,
;; before sending keepalive packets
tcp_keepidle = {{ conf.get('tcp-keepidle', '10') }}
;; The time between individual keepalive probes.
tcp_keepintvl = {{ conf.get('tcp-keepintvl', '10') }}
;; DNS lookup caching time
;dns_max_ttl = 15
;; DNS zone SOA lookup period
;dns_zone_check_period = 0
;; DNS negative result caching time
;dns_nxdomain_ttl = 15

;; database name = connect string
;;
;; connect string params:
;;   dbname= host= port= user= password=
;;   client_encoding= datestyle= timezone=
;;   pool_size= connect_query=
[databases]

* = host=::1 port=5432

