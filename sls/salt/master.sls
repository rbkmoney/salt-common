include:
  - salt.pkg
  - salt.repos
  - .selinux

salt-master:
  service.running:
    - enable: True
    - watch:
      - pkg: python2
      - pkg: cython
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
