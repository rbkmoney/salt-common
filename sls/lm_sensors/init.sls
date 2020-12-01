{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

sys-apps/lm-sensors:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('sys-apps/lm-sensors') }}
    - require:
      - file: gentoo.portage.packages

lm_sensors:
  service.running:
    - enable: True
    - watch:
      - pkg: sys-apps/lm-sensors
{% if grains['init'] == 'openrc' %}
      - file: /etc/conf.d/lm_sensors
      - file: /etc/init.d/lm_sensors

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
{% endif %}

