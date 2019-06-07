include:
  - gentoo.makeconf
  - lib.glibc
  - lib.libmicrohttpd

{% set collectd = salt['pillar.get']('collectd', {}) -%}
{% set collectd_version = collectd.get('version', '>=5.8') %}
{% set collectd_use = collectd.get('use', ['udev', 'xfs']) %}
{% set collectd_packaged = collectd.get('packaged', False) %}
{% set extra_plugins = collectd.get('extra-plugins', []) %}
{% if 'java' in extra_plugins and not 'java' in collectd_use %}
{% do collectd_use.append('java') %}
{% endif %}

{% set makeconf_collectd_plugins = 'aggregation apcups cgroups chrony contextswitch conntrack cpu cpufreq csv curl curl_json curl_xml dbi df disk entropy ethstat exec filecount fscache interface iptables ipvs irq load logfile memcached memory nfs netlink network nginx numa hugepages processes python sensors swap syslog log_logstash statsd table tail target_notification treshold unixsock uptime users vmem write_graphite write_riemann write_prometheus ' + ' '.join(collectd.get('extra-plugins', [])) %}

manage-collectd-plugins:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set COLLECTD_PLUGINS '"{{ makeconf_collectd_plugins }}"'
    - require:
      - file: augeas-makeconf

app-metrics/collectd:
  pkg.installed:
    - require:
      - pkg: sys-libs/glibc
      - pkg: net-libs/libmicrohttpd
    - version: "{{ collectd_version }}[{{ ','.join(collectd_use) }}]"
    {% if collectd_packaged %}
    - binhost: force
    {% endif %}
    - watch:
      - augeas: manage-collectd-plugins
