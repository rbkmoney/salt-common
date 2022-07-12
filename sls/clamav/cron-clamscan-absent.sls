include:
  - cron

cron-clamscan:
  cron.absent:
    - identifier: clamscan
    - user: root

cron-freshclam:
  cron.absent:
    - identifier: freshclam
    - user: root
