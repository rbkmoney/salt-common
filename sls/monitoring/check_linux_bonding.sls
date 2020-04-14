{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

net-analyzer/nagios-check_linux_bonding:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/nagios-check_linux_bonding') }}
    - require:
      - file: gentoo.portage.packages
