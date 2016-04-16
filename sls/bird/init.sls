# -*- mode: yaml -*-
pkg_bird:
  pkg.installed:
    - pkgs:
      - net-misc/bird: "~>=1.5.0[ipv6]"

/etc/init.d/bird:
  file.managed:
    - source: salt://bird/bird.initd
    - mode: 750
    - user: root
    - group: root

/etc/init.d/bird6:
  file.symlink:
    - target: /etc/init.d/bird
    - force: True

/etc/bird.conf:
    file.managed:
    - source: salt://bird/bird.conf
    - replace: False
    - mode: 640
    - user: root
    - group: root

/etc/bird6.conf:
  file.managed:
    - source: salt://bird/bird.conf
    - replace: False
    - mode: 640
    - user: root
    - group: root

bird:
  service.running:
    - enable: True
    - watch:
      - file: /etc/init.d/bird
      - pkg: pkg_bird

bird6:
  service.running:
    - enable: True
    - watch:
      - file: /etc/init.d/bird6
      - pkg: pkg_bird

bird-reload:
  service.running:
    - name: bird
    - reload: True
    - require:
      - file: /etc/bird.conf

bird6-reload:
  service.running:
    - name: bird6
    - reload: True
    - require:
      - file: /etc/bird6.conf
