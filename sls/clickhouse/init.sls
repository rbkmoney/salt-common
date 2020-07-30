{% set external_dictionaries = salt.pillar.get('clickhouse:external_dictionaries', []) %}
include:
  - .pkg
  - .service
  - .users
  {% if external_dictionaries != [] %}
  - clickhouse.external_dictionaries
  {% endif %}
  
extend:
  clickhouse-server:
    service.running:
      - watch:
        - pkg: dev-db/clickhouse
