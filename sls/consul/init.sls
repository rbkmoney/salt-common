include:
  - .service
  - .pkg

extend:
  consul:
    service.running:
      - watch:
        - pkg: app-admin/consul
