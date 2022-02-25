include:
  - .pkg
  - .service

extend:
  consul:
    service.running:
      - watch:
        - pkg: app-admin/consul
