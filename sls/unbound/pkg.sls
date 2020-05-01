{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - lib.glibc

net-dns/unbound:
  pkg.installed:
    - require:
      - file: gentoo.portage.packages
      - pkg: sys-libs/glibc
    - pkgs:
      - {{ pkg.gen_atom('net-dns/unbound') }}
