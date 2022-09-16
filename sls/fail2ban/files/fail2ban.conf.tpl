# Fail2Ban main configuration file
# Managed by Salt#
{% set conf = salt.pillar.get("fail2ban:conf", {}) %}
{% macro op(o, name, default, key=None) %}
{{ name }} = {{ o.get(key if key else name, default) }}
{%- endmacro %}
[DEFAULT]

# Option: loglevel
# Notes.: Set the log level output.
# Values: [ LEVEL ]  Default: INFO
{{ op(conf, 'loglevel', 'INFO') }}

# Option: logtarget
# Notes.: Set the log target. This could be a file, SYSLOG, STDERR or STDOUT.
#         Only one log target can be specified.
#         If you change logtarget from the default value and you are
#         using logrotate -- also adjust or disable rotation in the
#         corresponding configuration file
#         (e.g. /etc/logrotate.d/fail2ban on Debian systems)
# Values: [ STDOUT | STDERR | SYSLOG | SYSOUT | FILE ]  Default: STDERR
{{ op(conf, 'logtarget', 'SYSLOG') }}

# Option: syslogsocket
# Notes: Set the syslog socket file. Only used when logtarget is SYSLOG
#        auto uses platform.system() to determine predefined paths
# Values: [ auto | FILE ]  Default: auto
{{ op(conf, 'syslogsocket', 'auto') }}

# Option: socket
# Notes.: Set the socket file. This is used to communicate with the daemon. Do
#         not remove this file when Fail2ban runs. It will not be possible to
#         communicate with the server afterwards.
# Values: [ FILE ]  Default: /run/fail2ban/fail2ban.sock
{{ op(conf, 'socket', '/run/fail2ban/fail2ban.sock') }}

# Option: pidfile
# Notes.: Set the PID file. This is used to store the process ID of the
#         fail2ban server.
# Values: [ FILE ]  Default: /run/fail2ban/fail2ban.pid
{{ op(conf, 'pidfile', '/run/fail2ban/fail2ban.pid') }}

# Options: dbfile
# Notes.: Set the file for the fail2ban persistent data to be stored.
#         A value of ":memory:" means database is only stored in memory
#         and data is lost when fail2ban is stopped.
#         A value of "None" disables the database.
# Values: [ None :memory: FILE ] Default: /var/lib/fail2ban/fail2ban.sqlite3
{{ op(conf, 'dbfile', '/var/lib/fail2ban/fail2ban.sqlite3') }}

# Options: dbpurgeage
# Notes.: Sets age at which bans should be purged from the database
# Values: [ SECONDS ] Default: 86400 (24hours)
{{ op(conf, 'dbpurgeage', '1d') }}

# Options: dbmaxmatches
# Notes.: Number of matches stored in database per ticket (resolvable via
#         tags <ipmatches>/<ipjailmatches> in actions)
# Values: [ INT ] Default: 10
{{ op(conf, 'dbmaxmatches', '10') }}

[Definition]


[Thread]

# Options: stacksize
# Notes.: Specifies the stack size (in KiB) to be used for subsequently created threads,
#         and must be 0 or a positive integer value of at least 32.
# Values: [ SIZE ] Default: 0 (use platform or configured default)
#stacksize = 0
