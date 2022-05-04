include:
  - .repos
  - .selinux
  - .pkg

salt-master:
  service.running:
    - enable: True
    - order: last
    - watch:
      - file: /etc/salt/master
      - file: /etc/salt/master.d/roots.conf
      - pkg: app-admin/salt

/etc/salt/master:
  file.serialize:
    - require:
      - pkg: app-admin/salt
    - dataset_pillar: 'salt:master:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: 640
