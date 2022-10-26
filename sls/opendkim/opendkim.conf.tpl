# Managed by Salt    
{% set conf = salt['pillar.get']('opendkim:conf') %}

UserID                  {{ conf.get('user', 'opendkim') }}
Umask                   {{ conf.get('umask', '113') }}
PidFile                 {{ conf.get('pidfile', '/run/opendkim.pid') }}
Socket                  {{ conf.get('socket', 'unix:/run/opendkim.sock') }}
Statistics              /var/lib/opendkim/stats.dat

Canonicalization        {{ conf.get('canonicalization', 'relaxed/simple') }}

SigningTable            refile:/etc/opendkim/signing-table
KeyTable                /etc/opendkim/key-table
InternalHosts           /etc/opendkim/internal-hosts
ExternalIgnoreList      /etc/opendkim/external-ignore-list

Syslog                  {{ conf.get('syslog', 'yes') }}
SyslogSuccess           {{ conf.get('syslog-success', 'yes') }}
LogWhy                  {{ conf.get('log-why', 'yes') }}

SendReports             {{ conf.get('send-reports', 'yes') }}
{% for k,v in conf.get('extra', {}).items() %}
k v
{% endfor %}

