include:
  - .pkg
  - .minion-config
  - .selinux

salt-minion:
  service.running:
    - enable: True
    - watch:
      - pkg: cython
      - pkg: python3
      - pkg: app-admin/salt
      - file: /etc/salt/minion


