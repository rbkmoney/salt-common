{% set data_dir = salt.pillar.get('consul:main-config:data_dir').rstrip('/') %}
{% set p_u_consul = salt.pillar.get('users:present:consul', {}) %}
{% if p_u_consul %}
include:
  - users
{% endif %}
{% set data_dir_state = True %}
{% if p_u_consul %}
  {%- set consul_home = p_u_consul.get('home', False) %}
  {%- if consul_home and consul_home.endswith('/') %}
  {%- set consul_home = consul_home.rstrip('/') %}
  {%- endif %}

  {%- if consul_home == data_dir %}
  {%- set data_dir_state = False %}
  {%- endif %}
{% endif %}

{% if grains['init'] == 'openrc' %}
/etc/conf.d/consul:
  file.managed:
    - source: salt://{{ slspath }}/files/consul.confd.tpl
    - template: jinja
    - mode: 644
{% elif grains['init'] == 'systemd' %}
/etc/conf.d/consul: file.absent

/etc/systemd/system/consul.service:
  file.managed:
    - source: salt://{{ slspath }}/files/consul.service
    - mode: 644
{% endif %}

/etc/consul.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: consul
    - group: consul

/etc/consul.d/main-config.json:
  file.serialize:
    {% if salt['pillar.get']('consul:main-config', False) %}
    - dataset_pillar: consul:main-config
    {% else %}
    - dataset:
        server: true
        bootstrap_expect: 1
        ui: true
    {% endif %}
    - formatter: json
    - mode: 644
    - user: consul
    - group: consul
    - require:
      - file: /etc/consul.d/

/etc/consul.d/private-config.json:
    file.serialize:
    {% if salt['pillar.get']('consul:private-config', False) %}
    - dataset_pillar: consul:private-config
    {% else %}
    - dataset: {}
    {% endif %}
    - formatter: json
    - mode: 600
    - user: consul
    - group: consul
    - require:
      - file: /etc/consul.d/

/etc/consul.d/reloadable-config.json:
  file.serialize:
    {% if salt['pillar.get']('consul:reloadable-config', False) %}
    - dataset_pillar: consul:reloadable-config
    {% else %}
    - dataset: {}
    {% endif %}
    - formatter: json
    - mode: 644
    - user: consul
    - group: consul
    - require:
      - file: /etc/consul.d/

{% if data_dir_state %}
{{ data_dir }}/:
  file.directory:
    - create: True
    - mode: 755
    - user: consul
    - group: consul
    - recurse:
      - user
      - group
    - require:
      - file: /etc/consul.d/
{% endif %}
