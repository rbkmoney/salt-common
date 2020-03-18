include:
  - salt.pkg
  - salt.master

salt-syndic:
  service.running:
    - enable: True
    - watch:
      - pkg: cython
      - pkg: app-admin/salt
      - file: /etc/salt/master
