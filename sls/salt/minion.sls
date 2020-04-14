include:
  - .pkg
  - .minion-config
  - .selinux

salt-minion:
  service.running:
    - enable: True
    - watch:
      - pkg: app-admin/salt
      - file: /etc/salt/minion


