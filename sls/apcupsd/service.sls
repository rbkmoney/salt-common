/etc/apcupsd/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

{% set apcupsd = salt.pillar.get("apcupsd", {}) %}
{% if 'instances' in apcupsd %}
{% for instance in apcupsd["instances"] %}
# Only works on OpenRC for now
/etc/apcupsd/{{ instance }}.conf:
  file.managed:
    - source:
      - salt://{{ slspath }}/files/by-id/{{ grains.id}}/apcupsd.conf.tpl
      - salt://{{ slspath }}/files/apcupsd.conf.tpl
    - template: jinja
    - defaults:
        instance: {{ instance }}
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/apcupsd/

/etc/init.d/apcupsd.{{ instance }}:
  file.symlink:
    - target: /etc/init.d/apcupsd

apcupsd:
  service.dead:
    - enable: False

apcupsd.{{ instance }}:
  service.running:
    - enable: True
    - watch:
      - service: apcupsd
      - file: /etc/init.d/apcupsd.{{ instance }}
      - file: /etc/apcupsd/{{ instance }}.conf
{% endfor %}
{% else %}
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

apcupsd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/apcupsd/apcupsd.conf
{% endif %}

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
