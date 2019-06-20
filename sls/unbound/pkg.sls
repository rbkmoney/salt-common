{% import 'pkg/common' as pkg %}
include:
  - lib.glibc
  - lib.ldns
  - lib.libevent
  - lib.libsodium

net-dns/unbound:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-dns/unbound') }}
