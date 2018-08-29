include:
  - consul.pkg

/etc/conf.d/consul:
  file.managed:
    - source: salt://consul/files/consul.confd.tpl
    - template: jinja
    - mode: 644

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
