/etc/salt/minion:
  file.serialize:
    - dataset_pillar: 'salt:minion:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: 640
