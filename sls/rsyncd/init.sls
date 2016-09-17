# -*- mode: yaml -*-

rsync:
  pkg.latest:
    - name: 'net-misc/rsync'

/etc/rsyncd.conf:
  file.managed:
    - source: salt://rsyncd/rsyncd.conf
    - mode: 644
    - user: root
    - group: root

/etc/rsyncd.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

rsyncd:
  service.running:
    - enable: True
    - watch:
      - pkg: rsync
      - file: /etc/rsyncd.conf
      - file: /etc/rsyncd.d/
