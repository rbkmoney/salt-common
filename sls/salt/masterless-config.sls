/etc/salt/minion-masterless/minion:
  file.serialize:
    - dataset_pillar: 'salt:minmasterless:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
