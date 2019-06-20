{% import 'pkg/common' as pkg %}
nagios-plugins:
  pkg.purged:
    - name: net-analyzer/nagios-plugins
  portage_config.flags:
    - accept_keywords: []
    - use: []

monitoring-plugins:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/monitoring-plugins') }}
    - require:
      - pkg: nagios-plugins

net-analyzer/monitoring-plugins:
  {{ pkg.gen_portage_config('net-analyzer/monitoring-plugins', watch_in={'pkg': 'monitoring-plugins'})|indent(8) }}
