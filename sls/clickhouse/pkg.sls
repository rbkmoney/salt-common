{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-db/clickhouse:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('dev-db/clickhouse') }}
    - require:
      - cmd: gentoo.portage.packages
  {{ pkg.gen_portage_config('dev-db/clickhouse', watch_in={'pkg': 'dev-db/clickhouse'})|indent(8) }}
