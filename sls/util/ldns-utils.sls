{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

net-dns/ldns-utils:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-dns/ldns-utils') }}
    - require:
      - file: gentoo.portage.packages
