include:
  - cron

cron-clamscan:
  cron.absent:
    - identifier: clamscan
    - user: root

cron-clamdscan:
  cron.absent:
    - identifier: clamdscan
    - user: root
