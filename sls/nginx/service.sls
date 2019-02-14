{% set worker_processes = salt['pillar.get'](
  'nginx:worker:processes', grains.get('num_cpus', 2)) -%}
{% set worker_connections = salt['pillar.get']('nginx:worker:connections', 4096) -%}
{% set worker_rlimit_nofile = salt['pillar.get'](
  'nginx:worker:rlimit_nofile',  worker_processes*worker_connections*2) -%}
{% set ssl_protocols = salt['pillar.get']('nginx:ssl:protocols', 'TLSv1.1 TLSv1.2') %}
{% set ssl_ciphers = salt['pillar.get']('nginx:ssl:ciphers', ':'.join([
'ECDHE-ECDSA-AES256-GCM-SHA384', 'ECDHE-ECDSA-AES128-GCM-SHA256',
'ECDHE-RSA-AES256-GCM-SHA384', 'ECDHE-RSA-AES128-GCM-SHA256',
'ECDHE-ECDSA-AES128-SHA', 'ECDHE-RSA-AES128-SHA',
'ECDH-ECDSA-AES128-SHA', 'ECDH-RSA-AES128-SHA',
'DHE-RSA-AES128-SHA', 'AES128-SHA256', 'AES128-SHA',
'!3DES', '!MD5', '!aNULL', '!EDH'])) -%}

nginx:
  service.running:
    - enable: True
    - watch:
      - file: /etc/nginx/nginx.conf

nginx-reload:
  # This is for watch_in reloads
  service.running:
    - name: nginx
    - reload: True
    - require:
      - file: /etc/nginx/nginx.conf

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/files/nginx.conf.tpl
    - template: jinja
    - defaults:
        worker_processes: {{ worker_processes }}
        worker_connections: {{ worker_connections }}
        worker_rlimit_nofile: {{ worker_rlimit_nofile }}
        ssl_protocols: {{ ssl_protocols }}
        ssl_ciphers: {{ ssl_ciphers }}
        ssl_ecdh_curve: prime256v1
        ssl_session_cache: 'shared:SSL:20m'
        ssl_session_timeout: 120m
    - mode: 755
    - user: root
    - group: root

/etc/nginx/listen:
    file.managed:
    - source: salt://nginx/files/listen.conf
    - mode: 755
    - user: root
    - group: root
    - watch_in:
      - service: nginx

/etc/nginx/listen_ssl:
    file.managed:
    - source: salt://nginx/files/listen_ssl.conf
    - mode: 755
    - user: root
    - group: root
    - watch_in:
      - service: nginx

/etc/nginx/cf_real_ip.conf:
  file.managed:
    - source: salt://nginx/files/real_ip.conf.tpl
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
    - watch_in:
      - service: nginx-reload

/etc/nginx/includes/:
  file.recurse:
    - source: salt://nginx/files/includes
    - dir_mode: 755
    - file_mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: nginx-reload

/etc/nginx/main.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - watch_in:
      - service: nginx

/etc/nginx/conf.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - watch_in:
      - service: nginx

{% for f in ('tls-client', 'elastic-json-log')%}
/etc/nginx/conf.d/{{ f }}.conf:
  file.managed:
    - source: salt://nginx/files/conf.d/{{ f }}.conf
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/nginx/conf.d/
    - watch_in:
      - service: nginx-reload
{% endfor %}

/etc/nginx/vhosts.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/usr/lib/nginx/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/usr/lib/nginx/modules/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /usr/lib/nginx/

/var/cache/nginx/:
  file.directory:
    - create: True
    - mode: 755
    - user: nginx
    - group: nginx
    - watch_in:
      - service: nginx
