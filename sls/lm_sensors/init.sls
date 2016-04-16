# -*- mode: yaml -*-

lm_sensors:
  pkg.installed:
    - pkgs:
      - sys-apps/lm_sensors: '[sensord]'
  service.running:
    - enable: True
    - watch:
      - pkg: lm_sensors
      - file: /etc/init.d/lm_sensors
      - file: /etc/conf.d/lm_sensors

/etc/init.d/lm_sensors:
  file.managed:
    - source: salt://lm_sensors/lm_sensors.initd
    - mode: 755
    - user: root
    - group: root

/etc/conf.d/lm_sensors:
  file.managed:
    - source: salt://lm_sensors/lm_sensors.confd
    - mode: 644
    - user: root
    - group: root
