{% set clickhouse_version = salt['pillar.get']('clickhouse:version', '~:0/stable') %}
{% set clickhouse_use = salt['pillar.get']('clickhouse:use', ['kafka','tools','-mysql','-mongodb']) %}
{% set clickhouse_packaged = salt['pillar.get']('clickhouse:packaged', True) %}
include:
  - ssl.openssl
  - lib.poco
  - lib.capnproto

dev-db/clickhouse:
  portage_config.flags:
    - accept_keywords: ["~*"]
  package.installed:
    - version: "{{ clickhouse_version }}[{{ ','.join(clickhouse_use) }}]"
    {% if clickhouse_packaged %}
    - binhost: force
    {% endif %}
    - require:
      - portage_config: dev-db/clickhouse
