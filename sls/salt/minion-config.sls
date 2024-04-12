include:
  - .common

/etc/salt/minion:
  file.serialize:
    - dataset_pillar: 'salt:minion:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: 640
    - require:
      - file: /etc/salt/

/etc/salt/minion.d/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /etc/salt/
