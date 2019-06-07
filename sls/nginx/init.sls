include:
  - augeas.lenses
  - logrotate
  - .pkg
  - .service

extend:
  nginx:
    service.running:
      - watch:
        - pkg: www-servers/nginx
  nginx-reload:
    service.running:
      - require:
        - pkg: www-servers/nginx


/etc/logrotate.d/nginx:
  file.managed:
    - source: salt://nginx/files/nginx.logrotate
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/logrotate.d/
