include:
  - consul.pkg
  - consul.conf

{% set data_dir = salt['pillar.get']('consul:data-dir', '/var/lib/consul') %}
{% set consul_user = salt['pillar.get']('consul:user', 'consul') %}

{{ data_dir }}/:
  file.directory:
    - create: True
    - mode: 755
    - user: {{ consul_user }}

consul:
  service.running:
    - enable: True
    - watch:
      - pkg: app-admin/consul
      - file: /etc/conf.d/consul
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
      - pkg: app-admin/consul
      - file: /etc/conf.d/consul
      - file: /etc/consul.d/
      - file: /etc/consul.d/main-config.json
      - file: /etc/consul.d/private-config.json
      - file: {{ data_dir }}/
