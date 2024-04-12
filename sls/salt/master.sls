include:
  - .common
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
    - dataset_pillar: 'salt:master:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: 640
    - require:
      - file: /etc/salt/
      - pkg: app-admin/salt

/etc/salt/master.d/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode: 755
      - file: /etc/salt/

extend:
  /etc/salt/master.d/roots.conf:
    file.managed:
      - require:
        - file: /etc/salt/master.d/
