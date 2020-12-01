{% set machine_type = salt['grains.get']('machine_type', 'nil') %}
{% if grains['init'] == 'openrc' %}
include:
  - openrc.modules
{% endif %}

/etc/watchdog.conf:
  file.managed:
    - source: salt://watchdog/watchdog.conf.tpl
    - template: jinja
    - user: root
    - group: root
    - mode: 644

{% if machine_type == "raspberry pi" %}
/etc/modprobe.d/watchdog.conf:
  file.managed:
    - source: salt://watchdog/modprobe.d/bcm2708_wdog.conf
    - user: root
    - group: root
    - mode: 755

/etc/modules.d/watchdog.conf:
  file.managed:
    - source: salt://watchdog/modules.d/bcm2708_wdog.conf
    - user: root
    - group: root
    - mode: 755
{% endif %}

watchdog:
  pkg.latest:
    - name: sys-apps/watchdog
  service.running:
    - enable: True
    - watch:
      - pkg: watchdog
      - file: /etc/watchdog.conf
{% if grains['init'] == 'openrc' %}
      - file: /etc/conf.d/watchdog

/etc/conf.d/watchdog:
  file.managed:
    - source: salt://watchdog/watchdog.confd
    - user: root
    - group: root
    - mode: 644
{% endif %}
