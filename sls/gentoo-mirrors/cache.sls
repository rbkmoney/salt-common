# -*- mode: yaml -*-
include:
  - nginx
  - gentoo-mirrors.ssl-nginx

{% set dst_host = salt['pillar.get']('gentoo-mirror:dst-host',
      'gentoo.'+salt['grains.get']('domain', 'localdomain')) %}

/etc/nginx/includes/gentoo-miror-proxy-params.conf:
  file.managed:
    - source: salt://gentoo-mirrors/files/gentoo-miror-proxy-params.conf
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: nginx-reload

/etc/nginx/vhosts.d/gentoo-mirror-cache.conf:
  file.managed:
    - source: salt://gentoo-mirrors/files/gentoo_mirror-cache.nginx.conf.tpl
    - template: jinja
    - defaults:
        ssl: True
        ssl_cert_path: /etc/ssl/nginx/gentoo-mirror/certificate.pem
        ssl_key_path: /etc/ssl/nginx/gentoo-mirror/privkey.pem
        server_name: {{ dst_host }}
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/ssl/nginx/gentoo-mirror/certificate.pem
      - file: /etc/ssl/nginx/gentoo-mirror/privkey.pem
      - file: /etc/nginx/includes/gentoo-miror-proxy-params.conf
    - watch_in:
      - service: nginx-reload
