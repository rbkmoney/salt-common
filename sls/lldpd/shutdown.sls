include:
  - .pkg

lldpd:
  service.dead:
    - enable: False
    - watch:
      - pkg: net-misc/lldpd
