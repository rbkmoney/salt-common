include:
  - .pkg

/etc/chrony/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/chrony/chrony.conf:
  file.managed:
    - source: salt://chrony/files/chrony.conf.tpl
    - template: jinja
    - mode: 640
    - user: root
    - group: root
    - require:
      - file: /etc/chrony/

/etc/chrony/chrony.keys: file.absent

{% if grains.init == 'systemd' %}
/etc/conf.d/chronyd: file.absent
{% else %}
/etc/conf.d/chronyd:
  file.managed:
    - source: salt://chrony/files/chronyd.confd
    - mode: 644
    - watch_in:
      - service: chronyd
{% endif %}


disable-ntpd:
  service.dead:
    - name: ntpd
    - sig: ntpd
    - enable: False

disable-systemd-timesyncd:
  service.dead:
    - name: systemd-timesyncd
    - enable: False

chronyd:
  service.running:
    - enable: True
    - require:
      - service: disable-ntpd
      - service: disable-systemd-timesyncd
    - watch:
      - pkg: net-misc/chrony
      - file: /etc/chrony/chrony.conf
      - file: /etc/chrony/chrony.keys
