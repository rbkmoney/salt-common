include:
  - .pkg
  - .service
  - .users

extend:
  clickhouse-server:
    service.running:
      - watch:
        - pkg: dev-db/clickhouse
