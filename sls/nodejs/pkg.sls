{% set nodejs_packaged = salt.pillar.get('nodejs:packaged', True) %}
{% set nodejs_version = salt.pillar.get('nodejs:version', '~=8.15.1') %}
{% set nodejs_use = salt.pillar..get('nodejs:use', ['npm']) %}
include:
  - lib.libuv
  - lib.http-parser

net-libs/nodejs:
  pkg.installed:
    - version: "{{ nodejs_version }}[{{ ','.join(nodejs_use) }}]"
    {% if nodejs_packaged %}
    - binhost: force
    {% endif %}
    - require:
      - pkg: dev-libs/libuv
      - pkg: net-libs/http-parser
