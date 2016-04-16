# -*- mode: yaml -*-
openrc:
  pkg.latest:
    - name: sys-apps/openrc
  cmd.run:
    - name: rc
  cron.present:
    - identifier: rc
    - name: "/sbin/rc"
    - minute: '*/5'
    - user: root
