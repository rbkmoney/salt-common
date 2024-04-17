include:
  - .pkg

{% set bird_user = "bird" %}
{% set bird_group = "bird" %}
{% if grains.os == 'Gentoo' %}
{% set bird_dir = False %}
{% set bird_conf = "/etc/bird.conf" %}
{% elif grains.os_family == 'Debian' %}
{% set bird_dir = "/etc/bird/" %}
{% set bird_conf = "/etc/bird/bird.conf" %}
{% endif %}

{% if bird_dir %}
{{ bird_dir }}:
  file.directory:
    - create: True
    - user: {{ bird_user }}
    - group: {{ bird_group }}
    - mode: 750
    - require_in:
      - file: {{ bird_conf }}
{% endif %}

/etc/bird.conf:
  file.managed:
    - name: /etc/bird.conf
    - source: salt://bird/files/{{ grains.id }}/bird.conf
    - template: jinja
    - user: {{ bird_user }}
    - group: {{ bird_group }}
    - mode: 640
    - check_cmd: bird -p -c
    - require:
      - pkg: net-misc/bird

{% if grains.init == 'openrc' %}
/etc/init.d/bird:
  file.managed:
    - source: salt://bird/files/bird.initd
    - mode: 755
    - user: root
    - group: root
    - watch_in:
      - service: bird

/etc/init.d/bird6:
  file.absent:
    - require:
      - service: bird6

bird6:
  service.dead:
    - enable: False

{% elif grains.init == 'systemd' %}
# /etc/systemd/system/bird.service:
#   file.managed:
#     - source: salt://bird/files/bird.service.tpl
#     - template: jinja
#     - mode: 644
#     - user: root
#     - group: root
#     - watch_in:
#       - service: bird
{% endif %}

bird:
  service.running:
    - enable: True
    - require:
      - file: /etc/bird.conf
    - watch:
      - pkg: net-misc/bird

bird-reload:
  cmd.run:
    - name: birdc configure
    - onchanges:
      - file: /etc/bird.conf
    - require:
      - service: bird
