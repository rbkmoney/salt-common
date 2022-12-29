include:
  - .service
  - .pkg

extend:
  consul:
    service.running:
      - watch:
        - pkg: app-admin/consul
  /etc/consul.d/:
    file.directory:
      - require:
        - pkg: app-admin/consul
