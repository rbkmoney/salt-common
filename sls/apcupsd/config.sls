/etc/apcupsd/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/apcupsd/apcupsd.conf:
  file.managed:
    - source: salt://apcupsd/apcupsd.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/apcupsd/

/etc/apcupsd/changeme:
  file.managed:
    - source: salt://apcupsd/changeme
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apcupsd/

/etc/apcupsd/commfailure:
  file.managed:
    - source: salt://apcupsd/commfailure
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apcupsd/

/etc/apcupsd/commok:
  file.managed:
    - source: salt://apcupsd/commok
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apcupsd/

/etc/apcupsd/offbattery:
  file.managed:
    - source: salt://apcupsd/offbattery
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apcupsd/

/etc/apcupsd/onbattery:
  file.managed:
    - source: salt://apcupsd/onbattery
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apcupsd/
