include:
  - smartmontools.pkg

smartd_service:
  service.running:
    - name: smartd
    - enable: True
    - watch:
      - pkg: smartmontools
      - file: /etc/smartd.conf

/etc/smartd.conf:
  file.managed:
    - source: salt://smartmontools/smartd.conf.tpl
    - template: jinja
    - user: root
    - group: root
    - mode: 640
