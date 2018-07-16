include:
  - ssl.openssl
  - salt.pkg

salt-minion:
  service.running:
    - enable: True
    - watch:
      - pkg: openssl
      - pkg: cython
      - pkg: python2
      - pkg: app-admin/salt
      - file: /etc/salt/minion

/etc/salt/minion:
  file.serialize:
    - dataset_pillar: 'salt:minion:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: app-admin/salt
