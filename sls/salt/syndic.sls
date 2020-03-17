include:
  - salt.pkg
  - salt.master

salt-syndic:
  service.running:
    - enable: True
    - watch:
      - pkg: cython
      - pkg: python3
      - pkg: app-admin/salt
      - file: /etc/salt/master
