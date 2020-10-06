include:
  - .pkg

/etc/conf.d/lldpd:
  file.managed:
    - source: salt://lldpd/lldpd.confd
    - mode: 640
    - user: root

/etc/lldpd.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root

/etc/lldpd.d/salt.conf:
  file.managed:
    - source: salt://lldpd/lldpd.d/salt.conf
    - mode: 640
    - user: root

lldpd:
  service.running:
    - enable: True
    - watch:
      - pkg: net-misc/lldpd
      - file: /etc/lldpd.d/salt.conf
      - file: /etc/conf.d/lldpd

lldpcli-update:
  cmd.wait:
    - name: 'lldpcli update'
    - require:
      - pkg: net-misc/lldpd
      - service: lldpd
