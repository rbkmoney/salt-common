
apparmor:
  service.running:
    - enable: True

apparmor-reload:
  service.running:
    - name: apparmor
    - reload: True
