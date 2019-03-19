include:
  - .pkg
  - .service

extend:
  clickhouse-server:
    service.running:
      - watch:
        - pkg: openssl
        - pkg: dev-libs/poco
        - pkg: dev-libs/capnproto
        - pkg: dev-db/clickhouse
