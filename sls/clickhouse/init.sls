include:
  - .pkg
  - .service

extend:
  clickhouse-server:
    service.running:
      - watch:
        - pkg: dev-libs/poco
        - pkg: dev-libs/capnproto
        - pkg: dev-db/clickhouse
