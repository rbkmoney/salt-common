{% import 'pkg/common' as pkg %}
ldns:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-libs/ldns') }}
  {{ pkg.gen_portage_config('net-libs/ldns', watch_in={'pkg': 'ldns'})|indent(8) }}
