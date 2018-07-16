include:
  - ssl.openssl
  - salt.pkg
  - salt.master

salt-syndic:
  service.running:
    - enable: True
    - watch:
      - pkg: openssl
      - pkg: cython
      - pkg: python2
      - pkg: app-admin/salt
      - file: /etc/salt/master
