# -*- mode: yaml -*-
cronie:
  pkg.latest:
    - name: sys-process/cronie
    - use: inotify
  service.running:
    - sig: cron
    - enable: True
    - watch:
      - pkg: cronie

vixie-cron:
  pkg.purged:
    - name: sys-process/vixie-cron
  service:
    - disabled
