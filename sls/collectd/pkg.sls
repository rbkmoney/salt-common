{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc
  {% if grains.os == 'Gentoo' %}
  - gentoo.makeconf
  {% endif %}

{% set collectd = salt.pillar.get('collectd', {}) -%}
{% set extra_plugin_config = collectd.get('extra-plugin-config', {}) %}

{% set extra_plugins = [] %}
{% if "md" in extra_plugin_config %}{% do extra_plugins.append("md") %}{% endif %}
{% if "apcups" in extra_plugin_config %}{% do extra_plugins.append("apcups") %}{% endif %}
{% if "nginx" in extra_plugin_config %}{% do extra_plugins.append("nginx") %}{% endif %}
{% if "postfix" in extra_plugin_config %}{% do extra_plugins.append("postfix") %}{% endif %}

{% set makeconf_collectd_plugins = "aggregation cgroups chrony contextswitch conntrack cpu cpufreq csv curl curl_json curl_xml dbi df disk entropy ethstat exec filecount fscache interface iptables ipvs irq load logfile memcached memory nfs netlink network nginx numa hugepages processes python swap syslog log_logstash statsd table tail target_notification threshold unixsock uptime users vmem write_graphite write_riemann write_prometheus " + " ".join(extra_plugins) %}
{% if grains.os == "Gentoo" %}
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
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('app-metrics/collectd') }}
    - watch:
      - augeas: manage-collectd-plugins
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - collectd-core
      - collectd-utils
      - libyajl2 # json parsers
      - libprotobuf-c1
      - python3-protobuf
    {% if grains.os == 'Ubuntu' and grains.oscodename in ["noble"] %}
      - libmicrohttpd12t64 # write_prometheus
    {% else %}
      - libmicrohttpd12 # write_prometheus
    {% endif %}
    - install_recommends: False
    {% endif %}
    - require:
      {{ libc.pkg_dep() }}
