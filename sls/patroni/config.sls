{% set p_patroni = salt.pillar.get('patroni', {}) %}
{% set patroni_user = p_patroni.get('user', "postgres") %}
{% set patroni_group = p_patroni.get('group', patroni_user) %}

/etc/patroni/:
  file.directory:
    - create: True
    - user: root
    - group: {{ patroni_group }}
    - mode: 750

/etc/patroni/config.yml:
  file.serialize:
    - dataset_pillar: patroni:config
    - user: root
    - group: {{ patroni_group }}
    - mode: 640
    - require:
      - file: /etc/patroni/

/etc/patroni/hooks/:
  file.recurse:
    - source: salt://patroni/files/hooks
    - dir_mode: 750
    - file_mode: 750
    - user: root
    - group: {{ patroni_group }}
    - require:
      - file: /etc/patroni/

patroni:
  service.running:
    - enable: true
    - init_delay: 120
    - require:
      - pkg: dev-db/postgresql
      - pkg: dev-db/patroni
      - file: /etc/patroni/config.yml

patroni-reload:
  service.running:
    - name: patroni
    - reload: true
    - watch:
      - file: /etc/patroni/config.yml
