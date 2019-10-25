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
      {% if opendistro_enabled %}
      - pkg: app-misc/opendistro-security-kibana-plugin
      {% endif %}

/var/lib/kibana/:
  file.directory:
    - mode: 755
    - user: kibana
    - group: kibana
    - recurse:
      - user
      - group
    watch: 
      - pkg: app-misc/opendistro-security-kibana-plugin
