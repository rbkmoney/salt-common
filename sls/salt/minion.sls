include:
  - .pkg
  - .minion-config
  - .selinux

salt-minion:
  service.running:
    - enable: True
    - order: last
    - watch:
      - pkg: app-admin/salt
      - file: /etc/salt/minion


