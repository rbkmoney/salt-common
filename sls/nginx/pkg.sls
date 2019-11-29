{% import 'pkg/common' as pkg %}
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
  - gentoo.makeconf
  - gentoo.portage.packages

manage-nginx-modules:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set NGINX_MODULES_HTTP '"{{ ' '.join(modules_http) }}"'
      - set NGINX_MODULES_MAIL '"{{ ' '.join(modules_mail) }}"'
      - set NGINX_MODULES_STREAM '"{{ ' '.join(modules_stream) }}"'
    - require:
      - file: augeas-makeconf

# TODO: move this to separate file
dev-libs/libpcre:
  portage_config.flags:
    - use:
      - jit

www-servers/nginx:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('www-servers/nginx') }}
    - watch:
      - augeas: manage-nginx-modules
    - require:
      - file: gentoo.portage.packages
