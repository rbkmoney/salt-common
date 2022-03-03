include:
  - .pkg
  - .repos
  - .selinux

salt-master:
  service.running:
    - enable: True
    - order: last
    - watch:
      - pkg: app-admin/salt
      - file: /etc/salt/master
      - file: /etc/salt/master.d/roots.conf

/etc/salt/master:
  file.serialize:
    - require:
      - pkg: app-admin/salt
    - dataset_pillar: 'salt:master:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: 640
