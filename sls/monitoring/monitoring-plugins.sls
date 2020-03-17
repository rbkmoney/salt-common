{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

nagios-plugins:
  pkg.purged:
    - name: net-analyzer/nagios-plugins

monitoring-plugins:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/monitoring-plugins') }}
    - require:
      - pkg: nagios-plugins
      - file: gentoo.portage.packages      
