{% import 'pkg/common' as pkg %}
lm_sensors:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('sys-apps/lm_sensors') }}
  service.running:
    - enable: True
    - watch:
      - pkg: lm_sensors
      - file: /etc/init.d/lm_sensors
      - file: /etc/conf.d/lm_sensors

sys-apps/lm_sensors:
  {{ pkg.gen_portage_config('sys-apps/lm_sensors', watch_in={'pkg': 'lm_sensors'})|indent(8) }}  

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
