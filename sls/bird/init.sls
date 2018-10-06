include:
  - .pkg

/etc/init.d/bird6:
  file.absent:
    - require:
      - service: bird6

bird6:
  service.dead

/etc/init.d/bird:
  file.managed:
    - source: salt://bird/files/bird.initd
    - mode: 750
    - user: root
    - group: root

/etc/bird.conf:
  file.managed:
    - source: salt://bird/files/bird.conf
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

bird-reload:
  service.running:
    - name: bird
    - reload: True
    - require:
      - file: /etc/bird.conf
