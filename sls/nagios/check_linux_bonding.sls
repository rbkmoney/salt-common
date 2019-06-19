{% import 'pkg/common' as pkg %}
net-analyzer/nagios-check_linux_bonding:
  pkg.latest
  {{ pkg.gen_portage_config('net-analyzer/nagios-check_linux_bonding', watch_in={'pkg': 'net-analyzer/nagios-check_linux_bonding'})|indent(8) }}


cron-check_linux_bonding:
  cron.absent:
    - user: root
    - identifier: check_linux_bonding
