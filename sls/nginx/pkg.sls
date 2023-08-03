{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}

{% set makeconf_nginx = salt.pillar.get('makeconf:nginx', {}) -%}
{% set modules_http = makeconf_nginx.get('modules_http',
['access', 'auth_basic', 'autoindex', 'browser', 'cache_purge', 'charset', 'empty_gif',
'map', 'geo', 'geoip', 'gzip', 'gzip_static', 'headers_more', 'limit_req', 'limit_zone',
'memc', 'metrics', 'referer', 'rewrite', 'realip', 'proxy', 'scgi', 'uwsgi', 'fastcgi',
'ssi', 'ssl', 'reqstat','limit_conn',  'stub_status', 'vhost_traffic_status',
'userid', 'split_clients', 'sticky', 'upstream_zone', 'upstream_check',
'upstream_hash', 'upstream_keepalive', 'upstream_least_conn', 'upstream_ip_hash']) -%}
{% set modules_mail = makeconf_nginx.get('modules_mail', ['smtp', 'imap', 'pop3']) -%}
{% set modules_stream = makeconf_nginx.get('modules_stream', []) -%}

include:
  - lib.libc
{% if grains.os == 'Gentoo' %}
  - gentoo.makeconf
{% endif %}

{% if grains.os == 'Gentoo' %}
manage-nginx-modules:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set NGINX_MODULES_HTTP '"{{ ' '.join(modules_http) }}"'
      - set NGINX_MODULES_MAIL '"{{ ' '.join(modules_mail) }}"'
      - set NGINX_MODULES_STREAM '"{{ ' '.join(modules_stream) }}"'
    - require:
      - file: augeas-makeconf
{% endif %}

www-servers/nginx:
  pkg.installed:
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('www-servers/nginx') }}
    - watch:
      - augeas: manage-nginx-modules
    - require:
      - file: gentoo.portage.packages
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - nginx
      - nginx-common
      - nginx-core
    {% endif %}
