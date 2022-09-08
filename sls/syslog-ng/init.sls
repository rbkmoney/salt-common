# -*- mode: yaml -*-
include:
  - syslog-ng.pkg
  - logrotate

{% set syslog_local = salt['pillar.get']('syslog:local', True) %}
{% set syslog_udp_server = salt['pillar.get']('syslog:udp_server', False) %}
{% set syslog_udp_client = salt['pillar.get']('syslog:udp_client', False) %}

{% if salt.grains.get('init', 'openrc') == 'openrc' %}
/etc/conf.d/syslog-ng:
  file.managed:
    - source: salt://{{slspath}}/syslog-ng.confd.tpl
    - template: jinja
    - defaults:
        use_net: {{ syslog_udp_server or syslog_udp_client }}
    - mode: 644
    - user: root
    - group: root
{% else %}
/etc/conf.d/syslog-ng:
  file.absent
{% endif %}

/etc/syslog-ng/conf.d:
  file.directory:
    - mode: 755
    - user: root
    - group: root
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
log:
  group.present:
    - system: True

/etc/syslog-ng/syslog-ng.conf:
  file.managed:
    - source: salt://{{slspath}}/syslog-ng.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/syslog-ng/conf.d
      - group: log

/etc/logrotate.d/syslog-ng:
  file.managed:
    - source: salt://{{slspath}}/syslog-ng.logrotate
    - mode: 644
    - user: root
    - group: root

{% if syslog_udp_server %}
/etc/logrotate.d/syslog-ng-remote:
  file.managed:
    - source: salt://{{slspath}}/syslog-ng-remote.logrotate
    - mode: 644
    - user: root
    - group: root
{% endif %}

syslog-ng:
  service.running:
    - enable: True
    - watch:
      - group: log
      - pkg: app-admin/syslog-ng
      - file: /etc/syslog-ng/syslog-ng.conf
{% if salt.grains.get('init', 'openrc') == 'openrc' %}
      - file: /etc/conf.d/syslog-ng
{% endif %}
      # More files?
