{% import 'pkg/common' as pkg %}
include:
  - lib.libc

net-dns/unbound:
  pkg.installed:
    - require:
      - file: gentoo.portage.packages
      {{ libc_pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('net-dns/unbound') }}
