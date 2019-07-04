include:
  - .pkg
  - .service

extend:
  clickhouse-server:
    service.running:
      - watch:
        - pkg: dev-db/clickhouse
