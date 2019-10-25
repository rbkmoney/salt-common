{% set kibana_version = salt.pillar.get('kibana:version', '~>=6.3') %}
{% set opendistro_enabled = salt.pillar.get('kibana:opendistro:enabled', False) %}

include:
  - .pkg
  - .config
  {% if opendistro_enabled %}
  - .opendistro-security
  {% endif %}

kibana:
  service.running:
    - enable: True
    - watch:
      - pkg: www-apps/kibana-bin
      - file: /etc/kibana/kibana.yml
      - file: /etc/init.d/kibana
