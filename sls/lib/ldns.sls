{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

ldns:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-libs/ldns') }}
    - require:
      - file: gentoo.portage.packages
