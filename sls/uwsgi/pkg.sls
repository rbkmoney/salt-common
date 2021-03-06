{% import 'pkg/common' as pkg %}
include:
  - augeas
  - gentoo.makeconf
  - python
  - gentoo.portage.packages  

# TODO: Custom uWSGI deps and use flags
{% set uwsgi_plugins = '''cache carbon cheaper_busyness corerouter emperor_zeromq fastrouter http logfile logsocket mongodblog nagios ping rawrouter redislog router_basicauth router_cache router_expires router_hash router_http router_memcached router_metrics router_redirect router_rewrite router_static router_uwsgi rpc signal spooler sslrouter symcall syslog stats_pusher_statsd transformation_chunked transformation_gzip transformation_offload transformation_tofile ugreen xslt zergpool''' -%}

manage-uwsgi-plugins:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set UWSGI_PLUGINS '"{{ salt['pillar.get']('uwsgi:plugins', uwsgi_plugins) }}"'
    - require:
      - file: augeas-makeconf

www-servers/uwsgi:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('www-servers/uwsgi') }}
    - watch:
      - augeas: manage-uwsgi-plugins
    - require:
      - file: gentoo.portage.packages

/etc/conf.d/uwsgi:
  file.managed:
    - source: salt://uwsgi/files/uwsgi.confd
    - mode: 755
    - user: root
    - group: root

/etc/uwsgi.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
