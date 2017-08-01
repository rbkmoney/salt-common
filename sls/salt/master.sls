include:
  - ssl.openssl
  - salt
  - salt.repos

salt-master:
  service.running:
    - enable: True
    - watch:
      - pkg: openssl
      - pkg: python2
      - pkg: cython
      - pkg: app-admin/salt
      - pkg: salt-deps
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
