include:
  - .common

/etc/salt/minion-masterless/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /etc/salt/

/etc/salt/minion-masterless/minion:
  file.serialize:
    - dataset_pillar: 'salt:minmasterless:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - file: /etc/salt/minion-masterless/

