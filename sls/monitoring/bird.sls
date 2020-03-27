{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

nagios-bird:
  pkg.latest:
    - require:
      - file: gentoo.portage.packages
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/nagios-bird') }}
