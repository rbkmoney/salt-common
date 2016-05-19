include:
  - apcupsd.pkg
  - apcupsd.config

apcupsd:
  service.running:
    - enable: True
    - watch:
      - pkg: apcupsd_pkg
      - file: /etc/apcupsd/apcupsd.conf
