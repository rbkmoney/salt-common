/etc/patroni/config.yml:
  file.serialize:
    - dataset_pillar: patroni:config
    - user: root
    - group: root
    - mode: 644

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
