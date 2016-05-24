include:
  - cron
  - openrc

openrc_rc_cron_job:
  cron.present:
    - identifier: rc
    - name: "/sbin/rc"
    - minute: '*/5'
    - user: root
