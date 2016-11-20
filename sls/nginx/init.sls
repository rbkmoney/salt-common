# -*- mode: yaml -*-
{% set tengine = salt['pillar.get']('tengine', False) %}
include:
  - ssl.openssl
  - augeas.lenses
  - logrotate
  {% if tengine %}
  - gentoo.portage
  {% endif %}

{% set worker_processes = salt['grains.get']('num_cpus', 2) -%}
{% if worker_processes < 1 -%}
{% set worker_processes = 2 -%}
{% elif worker_processes < 4 -%}
{% set worker_processes = 4 -%}
{% endif %}
{% set worker_connections = 4096 -%}
{% set worker_rlimit_nofile = worker_processes*worker_connections*2 -%}

{% set makeconf_nginx_modules_http = '''access auth_basic autoindex browser charset empty_gif fastcgi geo geoip gzip gzip_static limit_req limit_zone lua map memcached proxy realip referer rewrite scgi spdy split_clients ssi ssl reqstat upstream_keepalive upstream_least_conn upstream_rbtree limit_conn upstream_session_sticky stub_status upstream_check upstream_consistent_hash upstream_ip_hash userid uwsgi''' -%}
{% set makeconf_nginx_modules_mail = 'smtp imap pop3' -%}
{% set ssl_ciphers = ':'.join([
'ECDHE-ECDSA-AES256-GCM-SHA384', 'ECDHE-ECDSA-AES128-GCM-SHA256',
'ECDHE-RSA-AES256-GCM-SHA384', 'ECDHE-RSA-AES128-GCM-SHA256',
'ECDHE-ECDSA-AES128-SHA', 'ECDHE-RSA-AES128-SHA',
'ECDH-ECDSA-AES128-SHA', 'ECDH-RSA-AES128-SHA',
'DHE-RSA-AES128-SHA', 'AES128-SHA256', 'AES128-SHA',
'!3DES', '!MD5', '!aNULL', '!EDH']) -%}

{% if tengine %}
manage-tengine-modules:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set TENGINE_STATIC_MODULES_HTTP '"{{ makeconf_nginx_modules_http }}"'
      - set TENGINE_SHARED_MODULES_HTTP '""'
      - set TENGINE_EXTERNAL_MODULES_HTTP '""'
      - set TENGINE_MODULES_MAIL '"{{ makeconf_nginx_modules_mail }}"'
    - require:
      - file: augeas-makeconf
{% else %}
manage-nginx-modules:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set NGINX_MODULES_HTTP '"{{ makeconf_nginx_modules_http }}"'
      - set NGINX_MODULES_MAIL '"{{ makeconf_nginx_modules_mail }}"'
    - require:
      - file: augeas-makeconf
{% endif %}

libpcre:
  portage_config.flags:
    - name: dev-libs/libpcre
    - use:
      - jit

{% if tengine %}
tengine:
  service.running:
    - enable: True
    - watch:
      - pkg: tengine
      - pkg: openssl
      - file: /etc/tengine/tengine.conf
  pkg.latest:
    - name: www-servers/tengine
    - require:
      - portage_config: libpcre
    - watch:
      - portage_config: tengine
      - augeas: manage-tengine-modules
  portage_config.flags:
    - name: www-servers/tengine
    - accept_keywords:
      - ~*
    - use:
      - aio
      - http
      - http-cache
      - ipv6
      - pcre
      - "-libatomic"
      - jemalloc
      - luajit
      - pcre-jit

nginx-reload:
  # This is for watch_in reloads
  service.running:
    - name: tengine
    - reload: True
    - require:
      - pkg: tengine
      - file: /etc/tengine/tengine.conf

  
/etc/tengine/tengine.conf:
  file.managed:
    - source: salt://nginx/tengine.conf.tpl
    - template: jinja
    - defaults:
        worker_processes: {{ worker_processes }}
        worker_connections: {{ worker_connections }}
        worker_rlimit_nofile: {{ worker_rlimit_nofile }}
        ssl_protocols: 'TLSv1.1 TLSv1.2'
        ssl_ciphers: {{ ssl_ciphers }}
        ssl_ecdh_curve: prime256v1
        ssl_session_cache: 'shared:SSL:20m'
        ssl_session_timeout: 120m
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/tengine/listen
      - file: /etc/tengine/listen_ssl
      - file: /etc/tengine/cf_real_ip.conf
      - file: /etc/tengine/includes/
      - file: /etc/tengine/vhosts.d/

/etc/tengine/listen:
    file.managed:
    - source: salt://nginx/listen.conf
    - mode: 755
    - user: root
    - group: root

/etc/tengine/listen_ssl:
    file.managed:
    - source: salt://nginx/listen_ssl.conf
    - mode: 755
    - user: root
    - group: root

/etc/tengine/includes/:
  file.recurse:
    - source: salt://nginx/includes
    - dir_mode: 755
    - file_mode: 644
    - user: root
    - group: root

/etc/tengine/includes/cf-real-ip.conf:
  file.managed:
    - source: salt://nginx/real_ip.conf.tpl
    - template: jinja
    - defaults:
        ips:
          -  204.93.240.0/24
          -  204.93.177.0/24
          -  199.27.128.0/21
          -  173.245.48.0/20
          -  103.21.244.0/22
          -  103.22.200.0/22
          -  103.31.4.0/22
          -  141.101.64.0/18
          -  108.162.192.0/18
          -  190.93.240.0/20
          -  188.114.96.0/20
          -  197.234.240.0/22
          -  198.41.128.0/17
          -  162.158.0.0/15
          -  2400:cb00::/32
          -  2606:4700::/32
          -  2803:f800::/32
          -  2405:b500::/32
          -  2405:8100::/32
        header: CF-Connecting-IP
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/tengine/includes/

/etc/tengine/vhosts.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/var/cache/tengine/:
  file.directory:
    - create: True
    - mode: 755
    - user: tengine
    - group: tengine

/etc/logrotate.d/tengine:
  file.managed:
    - source: salt://nginx/tengine.logrotate
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/logrotate.d/

{% else %}
nginx:
  service.running:
    - enable: True
    - watch:
      - pkg: nginx
      - pkg: openssl
      - file: /etc/nginx/nginx.conf
  pkg.latest:
    - name: www-servers/nginx
    - watch:
      - portage_config: nginx
      - augeas: manage-nginx-modules
  portage_config.flags:
    - name: www-servers/nginx
    - accept_keywords:
      - ~*
    - use:
      - aio
      - http
      - http2
      - http-cache
      - ipv6
      - pcre
      - libatomic
      - ssl
      - threads

nginx-reload:
  # This is for watch_in reloads
  service.running:
    - name: nginx
    - reload: True
    - require:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
  
/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/nginx.conf.tpl
    - template: jinja
    - defaults:
        worker_processes: {{ worker_processes }}
        worker_connections: {{ worker_connections }}
        worker_rlimit_nofile: {{ worker_rlimit_nofile }}
        ssl_protocols: 'TLSv1.1 TLSv1.2'
        ssl_ciphers: {{ ssl_ciphers }}
        ssl_ecdh_curve: prime256v1
        ssl_session_cache: 'shared:SSL:20m'
        ssl_session_timeout: 120m
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/nginx/listen
      - file: /etc/nginx/listen_ssl
      - file: /etc/nginx/cf_real_ip.conf
      - file: /etc/nginx/includes/
      - file: /etc/nginx/vhosts.d/

/etc/nginx/listen:
    file.managed:
    - source: salt://nginx/listen.conf
    - mode: 755
    - user: root
    - group: root

/etc/nginx/listen_ssl:
    file.managed:
    - source: salt://nginx/listen_ssl.conf
    - mode: 755
    - user: root
    - group: root

/etc/nginx/cf_real_ip.conf:
  file.managed:
    - source: salt://nginx/real_ip.conf.tpl
    - template: jinja
    - defaults:
        ips:
          -  204.93.240.0/24
          -  204.93.177.0/24
          -  199.27.128.0/21
          -  173.245.48.0/20
          -  103.21.244.0/22
          -  103.22.200.0/22
          -  103.31.4.0/22
          -  141.101.64.0/18
          -  108.162.192.0/18
          -  190.93.240.0/20
          -  188.114.96.0/20
          -  197.234.240.0/22
          -  198.41.128.0/17
          -  162.158.0.0/15
          -  2400:cb00::/32
          -  2606:4700::/32
          -  2803:f800::/32
          -  2405:b500::/32
          -  2405:8100::/32
        header: CF-Connecting-IP
    - mode: 755
    - user: root
    - group: root

/etc/nginx/includes/:
  file.recurse:
    - source: salt://nginx/includes
    - dir_mode: 755
    - file_mode: 644
    - user: root
    - group: root

/etc/nginx/vhosts.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/var/cache/nginx/:
  file.directory:
    - create: True
    - mode: 755
    - user: nginx
    - group: nginx

/etc/logrotate.d/nginx:
  file.managed:
    - source: salt://nginx/nginx.logrotate
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/logrotate.d/
{% endif %}
