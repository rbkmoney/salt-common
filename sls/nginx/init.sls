include:
  - ssl.openssl
  - augeas.lenses
  - logrotate
  - .pkg
  - .service

extend:
  nginx:
    service.running:
      - watch:
        - pkg: www-servers/nginx
        - pkg: openssl
  nginx-reload:
    service.running:
      - require:
        - pkg: www-servers/nginx
