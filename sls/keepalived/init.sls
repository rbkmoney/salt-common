include:
  - keepalived.pkg

# /etc/keepalived/keepalived.conf:
#   - file.managed:

keepalived:
  service.running:
    - enable: True
    - watch:
      - pkg: pkg_keepalived
