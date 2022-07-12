include:
  - .pkg
  - .svc
  
/etc/conf.d/clamd:
  file.managed:
    - source: salt://clamav/files/clamd-onacess.confd
    - mode: 644
    - user: root
    - group: root

/etc/clamav.conf:
  file.managed:
    - source: salt://clamav/files/clamd-onacess.conf
    - mode: 644
    - user: root
    - group: root

/etc/freshclam.conf:
  file.managed:
    - source: salt://clamav/files/freshclam.conf
    - mode: 644
    - user: root
    - group: root

extend:
  clamd:
    service.running:
      - watch:
        - pkg: app-antivirus/clamav
        - file: /etc/conf.d/clamd
        - file: /etc/clamav.conf
