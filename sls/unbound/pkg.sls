{% import 'pkg/common' as pkg %}
include:
  - lib.glibc

net-dns/unbound:
  pkg.installed:
    - require:
      - pkg: sys-libs/glibc
    - pkgs:
      - {{ pkg.gen_atom('net-dns/unbound') }}
