{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-libs/jemalloc:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-libs/jemalloc') }}
    - require:
      - file: gentoo.portage.packages
