{% import 'pkg/common' as pkg %}
include:
  - gentoo.makeconf
  - lib.libc

{%- set extra_plugins = salt.pillar.get('collectd:extra-plugins', []) %}
{% set makeconf_collectd_plugins = 'aggregation cgroups chrony contextswitch conntrack cpu cpufreq csv curl curl_json curl_xml dbi df disk entropy ethstat exec filecount fscache interface iptables ipvs irq load logfile memcached memory nfs netlink network nginx numa hugepages processes python swap syslog log_logstash statsd table tail target_notification threshold unixsock uptime users vmem write_graphite write_riemann write_prometheus ' + ' '.join(extra_plugins) %}

manage-collectd-plugins:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set COLLECTD_PLUGINS '"{{ makeconf_collectd_plugins }}"'
    - require:
      - file: augeas-makeconf

app-metrics/collectd:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-metrics/collectd') }}
    - watch:
      - augeas: manage-collectd-plugins
    - require:
      - file: gentoo.portage.packages
      {{ libc_pkg_dep() }}
