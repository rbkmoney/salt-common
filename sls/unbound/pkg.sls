{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

net-dns/unbound:
  pkg.installed:
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('net-dns/unbound') }}
