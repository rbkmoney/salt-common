# Managed by Salt
{% set c = salt.pillar.get('clamav:freshclam', {}) %}
# Path to the database directory.
# WARNING: It must match clamd.conf's directive!
# Default: hardcoded (depends on installation options)
DatabaseDirectory /var/lib/clamav

# Path to the log file (make sure it has proper permissions)
# Default: disabled
{% if 'update-log-file' in c %}
UpdateLogFile {{ c['update-log-file'] }}
{% else %}
# UpdateLogFile /var/log/clamav/freshclam.log
{% endif %}
# Maximum size of the log file.
# Value of 0 disables the limit.
# You may use 'M' or 'm' for megabytes (1M = 1m = 1048576 bytes)
# and 'K' or 'k' for kilobytes (1K = 1k = 1024 bytes).
# in bytes just don't use modifiers. If LogFileMaxSize is enabled,
# log rotation (the LogRotate option) will always be enabled.
# Default: 1M
LogFileMaxSize {{ c.get('log-file-max-size', '5M') }}

# Log time with each message.
# Default: no
LogTime {{ 'yes' if c.get('log-time', False) else 'no' }}

# Enable verbose logging.
# Default: no
LogVerbose {{ 'yes' if c.get('log-verbose', False) else 'no' }}

# Use system logger (can work together with UpdateLogFile).
# Default: no
LogSyslog {{ 'yes' if c.get('log-syslog', False) else 'no' }}

# Specify the type of syslog messages - please refer to 'man syslog'
# for facility names.
# Default: LOG_LOCAL6
LogFacility {{ c.get('log-facility', 'LOG_LOCAL6') }}

# Enable log rotation. Always enabled when LogFileMaxSize is enabled.
# Default: no
LogRotate {{ 'yes' if c.get('log-rotate', False) else 'no' }}

# This option allows you to save the process identifier of the daemon
# Default: disabled
PidFile {{ c.get('pidfile', '/run/clamav/freshclam.pid') }}

# By default when started freshclam drops privileges and switches to the
# "clamav" user. This directive allows you to change the database owner.
# Default: clamav (may depend on installation options)
DatabaseOwner clamav

# Use DNS to verify virus database version. Freshclam uses DNS TXT records
# to verify database and software versions. With this directive you can change
# the database verification domain.
# Default: current.cvd.clamav.net
DNSDatabaseInfo {{ c.get('dns-database-info', 'current.cvd.clamav.net') }}

# database.clamav.net is now the primary domain name to be used world-wide.
DatabaseMirror {{ c.get('database-mirror', 'database.clamav.net') }}
# How many attempts to make before giving up.
# Default: 3 (per mirror)
MaxAttempts {{ c.get('max-attempts', 5) }}

# With this option you can control scripted updates. It's highly recommended
# to keep it enabled.
# Default: yes
ScriptedUpdates {{ 'yes' if c.get('scripted-updates', True) else 'no' }}

# By default freshclam will keep the local databases (.cld) uncompressed to
# make their handling faster. With this option you can enable the compression;
# the change will take effect with the next database update.
# Default: no
CompressLocalDatabase {{ 'yes' if c.get('compress-local-database', False) else 'no' }}

# With this option you can provide custom sources for database files.
# This option can be used multiple times. Support for:
#   http(s)://, ftp(s)://, or file://
# Default: no custom URLs
{% if 'database-custom-url' in c %}
{% if c['database-custom-url'] is string %}
DatabaseCustomUrl {{ c['database-custom-url'] }}
{% else %}
{% for dcu in c['database-custom-url'] %}
DatabaseCustomUrl {{ dcu }}
{% endfor %}
{% endif %}
{% else %}
#DatabaseCustomUrl https://myserver.example.com/mysigs.ndb
{% endif %}

# This option allows you to easily point freshclam to private mirrors.
# If PrivateMirror is set, freshclam does not attempt to use DNS
# to determine whether its databases are out-of-date, instead it will
# use the If-Modified-Since request or directly check the headers of the
# remote database files. For each database, freshclam first attempts
# to download the CLD file. If that fails, it tries to download the
# CVD file. This option overrides DatabaseMirror, DNSDatabaseInfo
# and ScriptedUpdates. It can be used multiple times to provide
# fall-back mirrors.
# Default: disabled
{% if 'private-mirror' in c %}
{% if c['private-mirror'] is string %}
PrivateMirror {{ c['private-mirror'] }}
{% else %}
{% for mirror in c['private-mirror'] %}
PrivateMirror {{ mirror }}
{% endfor %}
{% endif %}
{% else %}
#PrivateMirror mirror1.example.com
{% endif %}

# Number of database checks per day.
# Default: 12 (every two hours)
Checks {{ c.get('checks', 12) }}

# Proxy settings
# The HTTPProxyServer may be prefixed with [scheme]:// to specify which kind
# of proxy is used.
#   http://     HTTP Proxy. Default when no scheme or proxy type is specified.
#   https://    HTTPS Proxy. (Added in 7.52.0 for OpenSSL, GnuTLS and NSS)
#   socks4://   SOCKS4 Proxy.
#   socks4a://  SOCKS4a Proxy. Proxy resolves URL hostname.
#   socks5://   SOCKS5 Proxy.
#   socks5h://  SOCKS5 Proxy. Proxy resolves URL hostname.
# Default: disabled
#HTTPProxyServer https://proxy.example.com
#HTTPProxyPort 1234
#HTTPProxyUsername myusername
#HTTPProxyPassword mypass

# If your servers are behind a firewall/proxy which applies User-Agent
# filtering you can use this option to force the use of a different
# User-Agent header.
# Default: clamav/version_number
#HTTPUserAgent SomeUserAgentIdString

# Use aaa.bbb.ccc.ddd as client address for downloading databases. Useful for
# multi-homed systems.
# Default: Use OS'es default outgoing IP address.
#LocalIPAddress aaa.bbb.ccc.ddd

# Send the RELOAD command to clamd.
# Default: no
NotifyClamd {{ c.get('notify-clamd', '/etc/clamd.conf') }}

# Run command after successful database update.
# Default: disabled
#OnUpdateExecute command

# Run command when database update process fails.
# Default: disabled
#OnErrorExecute command

# Run command when freshclam reports outdated version.
# In the command string %v will be replaced by the new version number.
# Default: disabled
#OnOutdatedExecute command

# Don't fork into background.
# Default: no
Foreground {{ 'yes' if c.get('foreground', False) else 'no' }}

# Enable debug messages in libclamav.
# Default: no
Debug {{ 'yes' if c.get('debug', False) else 'no' }}

# Timeout in seconds when connecting to database server.
# Default: 30
#ConnectTimeout 60

# Timeout in seconds when reading from database server.
# Default: 0
#ReceiveTimeout 1800

# With this option enabled, freshclam will attempt to load new
# databases into memory to make sure they are properly handled
# by libclamav before replacing the old ones.
# Default: yes
TestDatabases {{ 'yes' if c.get('test-databases', True) else 'no' }}

# This option enables support for Google Safe Browsing. When activated for
# the first time, freshclam will download a new database file
# (safebrowsing.cvd) which will be automatically loaded by clamd and
# clamscan during the next reload, provided that the heuristic phishing
# detection is turned on. This database includes information about websites
# that may be phishing sites or possible sources of malware. When using this
# option, it's mandatory to run freshclam at least every 30 minutes.
# Freshclam uses the ClamAV's mirror infrastructure to distribute the
# database and its updates but all the contents are provided under Google's
# terms of use.
# See https://transparencyreport.google.com/safe-browsing/overview
# and https://www.clamav.net/documents/safebrowsing for more information.
# Default: no
#SafeBrowsing yes

# This option enables downloading of bytecode.cvd, which includes additional
# detection mechanisms and improvements to the ClamAV engine.
# Default: yes
Bytecode {{ 'yes' if c.get('bytecode', True) else 'no' }}

# Include an optional signature databases (opt-in).
# This option can be used multiple times.
#ExtraDatabase dbname1
#ExtraDatabase dbname2

# Exclude a standard signature database (opt-out).
# This option can be used multiple times.
#ExcludeDatabase dbname1
#ExcludeDatabase dbname2
