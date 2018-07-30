{% set elastic_version = salt['pillar.get']('elastic:version', '~>=6.3') %}
include:
  - java.icedtea3

elasticsearch_pkg:
  pkg.installed:
    - pkgs:
      - app-misc/elasticsearch: '{{ elastic_version }}'
