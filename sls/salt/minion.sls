include:
  - .minion-config
  - .selinux
  - .pkg

salt-minion:
  service.running:
    - enable: True
    - order: last
    - watch:
      - file: /etc/salt/minion
      - pkg: app-admin/salt
