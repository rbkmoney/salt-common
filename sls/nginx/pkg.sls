{% set nginx_version = salt['pillar.get']('nginx:version', '>=1.14.1') %}
{% set nginx_packaged = salt['pillar.get']('nginx:packaged', False) %}
{% set makeconf_nginx_modules_http = '''access auth_basic autoindex browser charset empty_gif fastcgi geo geoip gzip gzip_static limit_req limit_zone lua map memcached proxy realip referer rewrite scgi split_clients ssi ssl reqstat upstream_keepalive upstream_least_conn upstream_rbtree limit_conn upstream_session_sticky stub_status upstream_check upstream_consistent_hash upstream_ip_hash userid uwsgi''' -%}
{% set makeconf_nginx_modules_mail = 'smtp imap pop3' -%}

manage-nginx-modules:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set NGINX_MODULES_HTTP '"{{ makeconf_nginx_modules_http }}"'
      - set NGINX_MODULES_MAIL '"{{ makeconf_nginx_modules_mail }}"'
    - require:
      - file: augeas-makeconf

# TODO: move this to separate file
dev-libs/libpcre:
  portage_config.flags:
    - use:
      - jit

www-servers/nginx:
  pkg.installed:
    - version: "{{ nginx_version }}"
    {% if nginx_packaged %}
    - binhost: force
    {% endif %}
    - watch:
      - portage_config: www-servers/nginx
      - augeas: manage-nginx-modules
  portage_config.flags:
    - use:
      - aio
      - http
      - http2
      - http-cache
      - ipv6
      - pcre
      - "-libatomic"
      - ssl
      - threads
