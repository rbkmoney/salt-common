{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc
  {% if grains.os == 'Gentoo' %}
  - gentoo.makeconf
  - python
  {% endif %}

# TODO: Custom uWSGI deps and use flags
{% set uwsgi_plugins = '''cache carbon cheaper_busyness corerouter emperor_zeromq fastrouter http logfile logsocket mongodblog nagios ping rawrouter redislog router_basicauth router_cache router_expires router_hash router_http router_memcached router_metrics router_redirect router_rewrite router_static router_uwsgi rpc signal spooler sslrouter symcall syslog stats_pusher_statsd transformation_chunked transformation_gzip transformation_offload transformation_tofile ugreen xslt zergpool''' -%}
{% if grains.os == 'Gentoo' %}
manage-uwsgi-plugins:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set UWSGI_PLUGINS '"{{ salt['pillar.get']('uwsgi:plugins', uwsgi_plugins) }}"'
    - require:
      - file: augeas-makeconf
{% endif %}

www-servers/uwsgi:
  pkg.installed:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('www-servers/uwsgi') }}
      {% elif grains.os_family == 'Debian' %}
      - uwsgi-core
      - uwsgi-emperor
      - uwsgi-plugin-python3
      - uwsgi-plugin-alarm-curl
      - uwsgi-plugin-alarm-xmpp
      {% endif %}
    {% if grains.os == 'Gentoo' %}
    - watch:
      - augeas: manage-uwsgi-plugins
    {% endif %}
    - require:
      {{ libc.pkg_dep() }}
