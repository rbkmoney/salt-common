{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}

{% set makeconf_nginx = salt.pillar.get('makeconf:nginx', {}) -%}
{% set modules_http = makeconf_nginx.get('modules_http',
['access', 'auth_basic', 'autoindex', 'browser', 'cache_purge', 'charset', 'empty_gif',
 'v2', 'v3',
 'map', 'geo', 'geoip', 'gzip', 'gzip_static', 'limit_req', 'limit_zone',
 'memc', 'referer', 'rewrite', 'realip', 'proxy', 'scgi', 'uwsgi', 'fastcgi',
 'ssi', 'ssl', 'reqstat','limit_conn',  'stub_status', 'vhost_traffic_status',
 'userid', 'split_clients', 'sticky', 'upstream_zone', 'upstream_check',
 'upstream_hash', 'upstream_keepalive', 'upstream_least_conn', 'upstream_ip_hash']) -%}
{% set modules_mail = makeconf_nginx.get('modules_mail', ['smtp', 'imap', 'pop3']) -%}
{% set modules_stream = makeconf_nginx.get('modules_stream', []) -%}
{% set custom_packages = salt.pillar.get('nginx:custom-packages', False) %}

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
      - {{ pkg.gen_atom('www-nginx/ngx-headers-more') }}
    - watch:
      - augeas: manage-nginx-modules
    - require:
      - file: gentoo.portage.packages
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      {% if custom_packages %}
      {% for p in custom_packages %}
      - {{ p }}
      {% endfor %}
      {% else %}
      - nginx
      - nginx-common
      - nginx-extras
      {% endif %}
    {% endif %}
    - require:
      {{ libc.pkg_dep() }}
