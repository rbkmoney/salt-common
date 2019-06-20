{% import 'pkg/common' as pkg %}
include:
  - gentoo.repos.{{ pillar.get('gentoo:portage:overlay') }}

riak_nagios_pkg:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/riak_nagios') }}

net-analyzer/riak_nagios:
  {{ pkg.gen_portage_config('net-analyzer/riak_nagios', watch_in={'pkg': 'riak_nagios_pkg'})|indent(8) }}
