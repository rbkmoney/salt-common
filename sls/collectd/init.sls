# -*- mode: yaml -*-
include:
  - gentoo.makeconf

{% set machine_type = salt['grains.get']('machine_type', 'nil') %}
{% set collectd = salt['pillar.get']('collectd', {}) -%}
{% set p_network = salt['pillar.get']('collectd:network', False) -%}
{% set configured_plugins = salt['pillar.get']('collectd:configured-plugins', '') %}

{% if machine_type == 'raspberry pi' %}
{% set makeconf_collectd_plugins = '''aggregation apcups contextswitch conntrack cpu cpufreq csv curl curl_json curl_xml dbi df disk entropy ethstat exec filecount fscache interface iptables load logfile memcached memory nfs netlink network nginx processes python syslog statsd table tail tcpconns unixsock uptime users vmem''' %}
{% else %}
{% set makeconf_collectd_plugins = 'aggregation apcups cgroups chrony contextswitch conntrack cpu cpufreq cpusleep csv curl curl_json curl_xml dbi df disk entropy ethstat exec filecount fscache interface iptables ipvs irq load logfile md memcached memory nfs netlink network nginx numa hugepages processes python sensors swap syslog log_logstash statsd table tail tcpconns target_notification thermal treshold unixsock uptime users uuid vmem write_graphite write_riemann write_prometheus' +
(' lvm' if 'lvm' in collectd else '') +
(' ceph' if 'ceph' in collectd else '') +
(' mysql' if 'mysql' in collectd else '') +
(' smart' if 'smart' in configured_plugins else '') +
(' hddtemp' if 'hddtemp' in configured_plugins else '') +
(' xencpu' if 'xencpu' in configured_plugins else '') +
(' notify_email' if 'notify_email' in configured_plugins else '') +
(' notify_nagios' if 'notify_nagios' in configured_plugins else '') +
(' snmp' if 'snmp' in configured_plugins else '') +
(' ipmi' if 'ipmi' in configured_plugins else '') +
(' openvpn' if 'openvpn' in configured_plugins else '')
%}
{% endif %}

manage-collectd-plugins:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set COLLECTD_PLUGINS '"{{ makeconf_collectd_plugins }}"'
    - require:
      - file: augeas-makeconf

collectd:
  service.running:
    - enable: True
    - watch:
      - pkg: collectd
      - file: /etc/conf.d/collectd
      - file: /etc/collectd/collectd.conf
      - file: /etc/collectd/types.db
      - file: /etc/collectd/conf.d/
  pkg.latest:
    - pkgs:
      - app-metrics/collectd: '~[udev,xfs]'
    - watch:
      - augeas: manage-collectd-plugins
  portage_config.flags:
    - name: app-metrics/collectd
    - accept_keywords:
      - ~*

/etc/conf.d/collectd:
  file.managed:
    - source: salt://collectd/collectd.confd
    - mode: 644
    - user: root
    - group: root

/etc/collectd:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: collectd
    - require:
      - pkg: collectd

/etc/collectd/collectd.conf:
  file.managed:
    - source: salt://collectd/collectd.conf.tpl
    - template: jinja
    - defaults:
        virtual_machine: {{ salt['grains.get']('virtual', False) }}
        machine_type: '{{ machine_type }}'
        nfs_server: {{ salt['grains.get']('nfs_server', False) }}
    - mode: 640
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd
      - file: /etc/collectd/types.db

/etc/collectd/types.db:
  file.managed:
    - source: salt://collectd/types.db
    - mode: 644
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd

{% if p_network.get('users', False) %}
/etc/collectd/collectd.passwd:
  file.managed:
    - source: salt://collectd/collectd.passwd
    - template: jinja
    - mode: 640
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd
    - watch_in:
      - service: collectd
{% endif %}

/etc/collectd/conf.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: collectd

