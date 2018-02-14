include:
  - nagios.server

/usr/local/lib/graphios/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode : 755

/usr/local/lib/graphios/graphios.py:
  file.managed:
    - salt: salt://nagios/files/graphios.py
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /usr/local/lib/graphios/

/usr/local/lib/graphios/graphios_backends.py:
  file.directory:
    - salt: salt://nagios/files/graphios_backends.py
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /usr/local/lib/graphios/

/etc/graphios/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode : 755

/etc/graphios/graphios.cfg:
  file.managed:
    - salt: salt://nagios/files/graphios.cfg.tpl
    - template: jinja
    - user: root
    - group: nagios
    - mode: 755
    - require:
      - file: /etc/graphios/
      - user: nagios

/etc/init.d/graphios:
  file.managed:
    - salt: salt://nagios/files/graphios.initd
    - user: root
    - group: root
    - mode: 755

graphios:
  service.running:
    - enable: True
    - watch:
      - user: nagios
      - file: /usr/local/lib/graphios/graphios.py
      - file: /usr/local/lib/graphios/graphios_backends.py
      - file: /etc/graphios/
      - file: /etc/graphios/graphios.cfg
      - file: /etc/init.d/graphios
