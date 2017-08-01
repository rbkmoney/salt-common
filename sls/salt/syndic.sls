include:
  - ssl.openssl
  - salt
  - salt.master

salt-syndic:
  service.running:
    - enable: True
    - watch:
      - pkg: openssl
      - pkg: cython
      - pkg: python2
      - pkg: app-admin/salt
      - pkg: salt-deps
      - file: /etc/salt/master
