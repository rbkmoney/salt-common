logrotate:
  pkg.latest:
    - pkgs:
      - app-admin/logrotate

/etc/cron.daily/logrotate:
  file.managed:
    - source: salt://logrotate/logrotate.cron.daily
    - mode: 755
    - user: root
    - group: root

/etc/logrotate.conf:
  file.managed:
    - source: salt://logrotate/logrotate.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/logrotate.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

