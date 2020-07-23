minion-masterless:
  file.managed:
    - name: /etc/salt/minion-masterless/minion
    - makedirs: True

/etc/salt/minion-masterless/minion:
  file.serialize:
    - dataset_pillar: 'salt:minmaster:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: '0644'
