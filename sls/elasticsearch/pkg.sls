{% set elastic_version = salt['pillar.get']('elastic:version', '~>=6.3') %}
include:
  - java.icedtea3

app-misc/elasticsearch:
  pkg.installed:
    - version: '{{ elastic_version }}'
