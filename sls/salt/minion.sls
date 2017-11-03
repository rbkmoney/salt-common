# -*- mode: yaml -*-
include:
  - ssl.openssl
  - salt

salt-minion:
  service.running:
    - enable: True
    - watch:
      - pkg: openssl
      - pkg: cython
      - pkg: python2
      - pkg: app-admin/salt
      - pkg: salt-deps
      - file: /etc/salt/minion

/etc/salt/minion:
  file.serialize:
    - require:
      - pkg: app-admin/salt
    - dataset_pillar: 'salt:minion:conf'
    - formatter: yaml
    - user: root
    - group: root
    - mode: 640
