include:
  - .pkg
  - .service

extend:
  uwsgi:
    service.running:
      - watch:
        - pkg: www-servers/uwsgi
