{% import 'pkg/common' as pkg %}
include:
  - java.icedtea3

app-misc/elasticsearch:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-misc/elasticsearch') }}
  {{ pkg.gen_portage_config('app-misc/elasticsearch', watch_in={'pkg': 'app-misc/elasticsearch'})|indent(8) }}
