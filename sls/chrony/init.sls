# -*- mode: yaml -*-
chrony:
  pkg.latest:
    - name: net-misc/chrony

/etc/chrony/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/chrony/chrony.conf:
  file.managed:
    - source: salt://chrony/chrony.conf.tpl
    - template: jinja
    - mode: 640
    - user: root
    - group: root
    - require:
      - file: /etc/chrony/

/etc/chrony/chrony.keys:
  file.managed:
    - source: salt://chrony/chrony.keys
    - mode: 640
    - require:
      - file: /etc/chrony/

/etc/conf.d/chronyd:
  file.managed:
    - source: salt://chrony/chronyd.confd
    - mode: 644

disable-ntpd:
  service.disabled:
    - name: ntpd
    - sig: ntpd

chronyd:
  service.running:
    - enable: True
    - require:
      - service: disable-ntpd
    - watch:
      - pkg: chrony
      - file: /etc/chrony/chrony.conf
      - file: /etc/chrony/chrony.keys
      - file: /etc/conf.d/chronyd
