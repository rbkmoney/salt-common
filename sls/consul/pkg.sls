{% set consul_version = salt['pillar.get']('consul:version', '<1.5') %}
{% set consul_packaged = salt['pillar.get']('consul:packaged', True) %}
{% if not consul_packaged %}
include:
  - go.dev-go.go-tools
  - go.dev-go.gox
{% endif %}

app-admin/consul:
  pkg.installed:
    - version: "{{ consul_version }}"
    {% if consul_packaged %}
    - binhost: force
    {% endif %}
