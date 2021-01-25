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

{% if grains.init == 'openrc' %}
/etc/conf.d/chronyd:
  file.managed:
    - source: salt://chrony/files/chronyd.confd
    - mode: 644
    - watch_in:
      - service: chronyd
{% else %}
/etc/conf.d/chronyd: file.absent
{% endif %}


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
      - pkg: net-misc/chrony
      - file: /etc/chrony/chrony.conf
      - file: /etc/chrony/chrony.keys
