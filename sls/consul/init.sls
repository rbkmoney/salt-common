include:
  - .pkg
  - .conf

{% set data_dir = salt.pillar.get('consul:main-config:data_dir') %}
{{ data_dir }}/:
  file.directory:
    - create: True
    - mode: 755
    - user: consul

consul:
  service.running:
    - enable: True
    - watch:
      - pkg: app-admin/consul
{% if grains['init'] == 'openrc' %}
      - file: /etc/conf.d/consul
{% endif %}
      - file: /etc/consul.d/
      - file: /etc/consul.d/main-config.json
      - file: /etc/consul.d/private-config.json
      - file: {{ data_dir }}/
    - require:
      - file: /etc/consul.d/reloadable-config.json

consul-reload:
  # This is for watch-in reloads
  service.running:
    - name: consul
    - reload: True
    - watch:
      - file: /etc/consul.d/reloadable-config.json
    - require:
      - service: consul
