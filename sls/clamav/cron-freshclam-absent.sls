include:
  - cron

cron-freshclam:
  cron.absent:
    - identifier: freshclam
    - user: root
