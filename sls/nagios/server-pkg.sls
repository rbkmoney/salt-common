{% import 'pkg/common' as pkg %}
nagios_pkg:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/nagios-core') }}
  {{ pkg.gen_portage_config('net-analyzer/nagios-core', watch_in={'pkg': 'nagios_pkg'})|indent(8) }}
