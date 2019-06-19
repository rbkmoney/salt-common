{% import 'pkg/common' as pkg %}
nagios_pkg:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/nagios-core') }}
