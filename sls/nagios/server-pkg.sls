{% import 'pkg/common' as pkg %}
nagios_pkg:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/nagios-core') }}
