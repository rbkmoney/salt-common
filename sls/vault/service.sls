{% set data_dir = "/var/lib/vault" %}

{% if grains['init'] == 'openrc' %}
/etc/conf.d/vault:
  file.managed:
    - source: salt://{{ slspath }}/files/vault.confd.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
{% elif grains['init'] == 'systemd' %}
/etc/conf.d/vault: file.absent

/etc/systemd/system/vault.service:
  file.managed:
    - source: salt://{{ slspath }}/files/vault.service.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
{% endif %}

/etc/vault.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: vault
    - group: vault

/etc/vault.d/main.hcl:
  file.serialize:
    {% if salt['pillar.get']('vault:main-config', False) %}
    - dataset_pillar: vault:main-config
    {% else %}
    - dataset:
        server: true
        bootstrap_expect: 1
        ui: true
    {% endif %}
    - formatter: json
    - mode: 644
    - user: vault
    - group: vault
    - require:
      - file: /etc/vault.d/

/etc/vault.d/reloadable.hcl:
  file.serialize:
    {% if salt['pillar.get']('vault:reloadable-config', False) %}
    - dataset_pillar: vault:reloadable-config
    {% else %}
    - dataset: {}
    {% endif %}
    - formatter: json
    - mode: 644
    - user: vault
    - group: vault
    - require:
      - file: /etc/vault.d/

{{ data_dir }}/:
  file.directory:
    - create: True
    - mode: 755
    - user: vault
    - group: vault
    - require:
      - file: /etc/vault.d/

vault:
  service.running:
    - enable: True
    - watch:
{% if grains['init'] == 'openrc' %}
      - file: /etc/conf.d/vault
{% endif %}
      - file: /etc/vault.d/
      - file: /etc/vault.d/main.hcl
      - file: /etc/vault.d/reloadable.hcl
      - file: {{ data_dir }}/
    - require:
      - file: /etc/vault.d/reloadable.hcl

vault-reload:
  # This is for watch-in reloads
  service.running:
    - name: vault
    - reload: True
    - watch:
      - file: /etc/vault.d/reloadable.hcl


