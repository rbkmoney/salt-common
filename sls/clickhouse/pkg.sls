{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-db/clickhouse:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('dev-db/clickhouse') }}
    - require:
      - file: gentoo.portage.packages
