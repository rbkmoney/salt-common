# Managed by Salt    
{% set conf = salt['pillar.get']('opendkim:conf') %}

UserID                  milter
Umask                   113
PidFile                 /run/opendkim/opendkim.pid
Socket                  unix:/run/opendkim/opendkim.sock
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

