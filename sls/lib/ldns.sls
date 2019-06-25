# TODO: rename ldns -> net-libs/ldns, check other states
{% import 'pkg/common' as pkg %}
ldns:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-libs/ldns') }}

net-libs/ldns:
  {{ pkg.gen_portage_config('net-libs/ldns', watch_in={'pkg': 'ldns'})|indent(8) }}
