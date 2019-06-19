{% import 'pkg/common' as pkg %}
dev-libs/jemalloc:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-libs/jemalloc') }}
  {{ pkg.gen_portage_config('dev-libs/jemalloc', watch_in={'pkg': 'dev-libs/jemalloc'})|indent(8) }}
