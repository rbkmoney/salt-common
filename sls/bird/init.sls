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

{% if grains['init'] == 'systemd' %}
/etc/systemd/system/bird.service:
  file.managed:
    - source: salt://bird/files/bird.service
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: bird
{% endif %}

bird:
  service.running:
    - enable: True
    - require:
      - file: /etc/bird.conf
    - watch:
      - file: /etc/init.d/bird
      - pkg: pkg_bird

bird-reload:
  cmd.run:
    - name: birdc configure
    - onchanges:
      - file: /etc/bird.conf
    - require:
      - service: bird
