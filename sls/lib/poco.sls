{% set poco_version = salt['pillar.get']('poco:version', '') %}
{% set poco_use = salt['pillar.get']('poco:use', ['-mysql','-mariadb','-mongodb']) %}
{% set poco_packaged = salt['pillar.get']('poco:packaged', True) %}
include:
  - ssl.openssl

dev-libs/poco:
  portage_config.flags:
    - accept_keywords: ['~*']
  package.latest:
    - version: "{{ poco_version }}[{{ ','.join(poco_use) }}]"
    {% if poco_packaged %}
    - binhost: force
    {% endif %}
    - require:
      - portage_config: dev-libs/poco
