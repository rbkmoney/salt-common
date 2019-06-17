include:
  - gentoo.makeconf
  - lib.glibc
  - lib.libmicrohttpd

{% set extra_plugins = collectd.get('extra-plugins', []) %}

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
    - pkgs:
      - {{ pkg.gen_atom('app-metrics/collectd', extra_use=['java'] if 'java' in extra_plugins else []) }}
    - version: "{{ collectd_version }}[{{ ','.join(collectd_use) }}]"
    - watch:
      - augeas: manage-collectd-plugins
