{% set elastic_version = salt['pillar.get']('elastic:version', '~>=5.1') %}
include:
  - java.icedtea3

elasticsearch_pkg:
  pkg.installed:
    - pkgs:
      - app-misc/elasticsearch: '{{ elastic_version }}'
