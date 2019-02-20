include:
  - .pkg
  - .service

extend:
  collectd:
    service.running:
      - watch:
        - pkg: app-metrics/collectd
