include:
  - salt.pkg
  - salt.master

salt-syndic:
  service.running:
    - enable: True
    - watch:
      - pkg: app-admin/salt
      - file: /etc/salt/master
