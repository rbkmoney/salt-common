# -*- mode: shell-script -*-
# Managed by salt
# Config file for /etc/init.d/syslog-ng

{% if use_net %}
rc_use="net"
{% endif %}

#rc_use="stunnel"

# For very customized setups these variables can be adjusted as needed
# but for most situations they should remain commented:
# SYSLOG_NG_CONFIGFILE=/etc/syslog-ng/syslog-ng.conf
# SYSLOG_NG_STATEFILE_DIR=/var/lib/syslog-ng
# SYSLOG_NG_STATEFILE=${SYSLOG_NG_STATEFILE_DIR}/syslog-ng.persist
# SYSLOG_NG_PIDFILE_DIR=/run
# SYSLOG_NG_PIDFILE=${SYSLOG_NG_PIDFILE_DIR}/syslog-ng.pid
# SYSLOG_NG_GROUP=root
# SYSLOG_NG_USER=root

# Put any additional options for syslog-ng here.
# See syslog-ng(8) for more information.

SYSLOG_NG_OPTS=""
