{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc
  {% if grains.os == 'Gentoo' %}
  - gentoo.makeconf
  {% endif %}

{%- set extra_plugins = salt.pillar.get('collectd:extra-plugins', []) %}
{% set makeconf_collectd_plugins = 'aggregation cgroups chrony contextswitch conntrack cpu cpufreq csv curl curl_json curl_xml dbi df disk entropy ethstat exec filecount fscache interface iptables ipvs irq load logfile memcached memory nfs netlink network nginx numa hugepages processes python swap syslog log_logstash statsd table tail target_notification threshold unixsock uptime users vmem write_graphite write_riemann write_prometheus ' + ' '.join(extra_plugins) %}
{% if grains.os == 'Gentoo' %}
manage-collectd-plugins:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set COLLECTD_PLUGINS '"{{ makeconf_collectd_plugins }}"'
    - require:
      - file: augeas-makeconf
{% endif %}

app-metrics/collectd:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('app-metrics/collectd') }}
      {% elif grains.os_family == 'Debian' %}
      - collectd-core
      - collectd-utils
      - libyajl2 # json parsers
      - libprotobuf-c1
      - python3-protobuf
      - libmicrohttpd12 # write_prometheus
      {% endif %}
    {% if grains.os == 'Gentoo' %}
    - watch:
      - augeas: manage-collectd-plugins
    {% endif %}
    - require:
      {{ libc.pkg_dep() }}
