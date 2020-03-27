{% import 'pkg/common' as pkg %}
include:
  - gentoo.repos.{{ pillar.get('overlay') }}
  - gentoo.portage.packages  

riak_nagios_pkg:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/riak_nagios') }}
    - require:
      - file: gentoo.portage.packages      
