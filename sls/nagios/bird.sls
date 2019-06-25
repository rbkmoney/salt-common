# -*- mode: yaml -*-
{% import 'pkg/common' as pkg %}
nagios-bird:
  pkg.latest

net-analyzer/nagios-bird:
  {{ pkg.gen_portage_config('net-analyzer/nagios-bird', watch_in={'pkg': 'nagios-bird'})|indent(8) }}
