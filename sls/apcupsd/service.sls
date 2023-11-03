/etc/apcupsd/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/apcupsd/apcupsd.conf:
  file.managed:
    - source:
      - salt://{{ slspath }}/files/by-id/{{ grains.id}}/apcupsd.conf.tpl
      - salt://{{ slspath }}/files/apcupsd.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/apcupsd/

{% for f in ["commfailure", "commok", "onbattery", "offbattery", "changeme"] %}
/etc/apcupsd/{{ f }}:
  file.managed:
    - source:
      - salt://{{ slspath }}/files/by-id/{{ grains.id}}/{{ f }}
      - salt://{{ slspath }}/files/{{ f }}
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apcupsd/
{% endfor %}

apcupsd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/apcupsd/apcupsd.conf
