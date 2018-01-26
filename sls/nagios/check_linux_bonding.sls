net-analyzer/nagios-check_linux_bonding:
  pkg.latest:
    - require:
      - portage_config: net-analyzer/nagios-check_linux_bonding
  portage_config.flags:
    - accept_keywords:
      - ~amd64

cron-check_linux_bonding:
  cron.absent:
    - user: root
    - identifier: check_linux_bonding
