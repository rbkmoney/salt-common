include:
  - go

app-metrics/prometheus:
  pkg.installed:
    - version: "~>=2.2.0"
    - require:
      - pkg: dev-lang/go
