# Managed by Salt
# restart-services configuration file
#
{% set conf = salt['pillar.get']('restart-services', {} ) %}
{% set defaults = {
 'always': '(acpid|apcupsd.*|atd|autofs|auditd|(bareos|bacula)-fd' +
 	   '|cronie|vixie-cron|dcron|incron|anacron|fcron|bcron' +
 	   '|haveged|irqbalance|lldpd|smartd|snmpd|mdadm|lvm-monitoring|dmeventd' +
	   '|dhcpd.*|named|unbound|nsd|ntpd|chronyd|timer_entropyd' +
	   '|rsyncd|rtorrentd|tor|haproxy.*' +
 	   '|postfix|qmail|opendkim|nullmailer|opendnssec|clamd' +
 	   '|sshd|zabbix-agentd|collectd|monit|filebeat|auditbeat' +
	   '|salt-(minion|syndic)|cf-.*)',
 'always-nodeps': '(udev|ulogd|rpc\..*|rsyslog|syslog-ng|metalog|lvmetad' +
 		  '|xencommons)',
 'critical': '((bareos|bacula)-(sd|dir)|.*ftpd|minidlna|git-daemon' +
 	     '|nginx|uwsgi|apache2|php-fpm|exim|dovecot|ejabberd|asterisk' +
	     '|mysql|postgresql-.*|mongodb|riak|dnet_.*|ceph-.*|radosgw.*' +
	     '|elasticsearch|kibana|carbon-.*|grafana|jenkins|consul|samba|nagios' +
	     '|openvpn\..*|racoon|bird|quagga|suricata.*' +
	     '|pacemaker|salt-master|watchdog|kafka' +
	     '|net\..*)',
 'critical-nodeps': '()',
 'always-reload-only': '(libvirtd)',
 'ignore': '(ntp-client|xendomains|xenstored)',
 'inittab-killall': '(/sbin/agetty)'
} %}
# Here you can classify your services
# (use extended regex without '^' and '$')
# Every option can also be an array of regular expressions

# Define services that can always be restarted
# Will run: rc-service $SV -- --ifstarted restart
SV_ALWAYS='{{ conf.get('always', defaults['always']) }}'

# Define services that can always be restarted, but excluding dependencies
# Will run: rc-service $SV -- --ifstarted --nodeps restart
SV_ALWAYS_WITH_NODEPS='{{ conf.get('always', defaults['always-nodeps']) }}'

# Define services that must not be restarted without
# the '--critical' option.
# Here you should put services where a restart would
# interrupt a service being offered to your users
# Will run: rc-service $SV -- --ifstarted restart
SV_CRITICAL='{{ conf.get('critical', defaults['critical']) }}'

# Define services that must not be restarted without
# the '--critical' option and that require "--nodeps"
# Here you should put services where a restart would
# interrupt a service being offered to your users
# Will run: rc-service $SV -- --ifstarted --nodeps restart
SV_CRITICAL_WITH_NODEPS='{{ conf.get('critical-nodeps', defaults['critical-nodeps']) }}'

# Define services than only need to be reloaded
# instead of restarted
# Will run: rc-service $SV -- --ifstarted reload
SV_ALWAYS_RELOAD_ONLY='{{ conf.get('always-reload-only', defaults['always-reload-only']) }}'

# Define services that should be ignored
SV_IGNORE='{{ conf.get('ignore', defaults['ignore']) }}'

# Define processes started via inittab that should be killed
INITTAB_KILLALL='{{ conf.get('inittab-killall', defaults['inittab-killall']) }}'

# load additional config files
# to extend options in another file use a syntax like SV_ALWAYS+=( myservice )
# where "myservice" can also be a regex
include /etc/restart-services.d/*.conf
