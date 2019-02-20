include:
  - gentoo.makeconf

{% set collectd = salt['pillar.get']('collectd', {}) -%}
{% set collectd_version = collectd.get('version', '>=5.8') %}
{% set collectd_use = collectd.get('use', ['udev', 'xfs']) %}
{% set collectd_packaged = collectd.get('packaged', False) %}
{% set configured_plugins = collectd.get('configured-plugins', '') %}

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

manage-collectd-plugins:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set COLLECTD_PLUGINS '"{{ makeconf_collectd_plugins }}"'
    - require:
      - file: augeas-makeconf

app-metrics/collectd:
  pkg.installed:
    - version: "{{ collectd_version }}[{{ ','.join(collectd_use) }}]"
    {% if collectd_packaged %}
    - binhost: force
    {% endif %}
    - watch:
      - augeas: manage-collectd-plugins
  portage_config.flags:
    - accept_keywords: []
