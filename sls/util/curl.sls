{% import 'pkg/common' as pkg %}
include:
  - lib.libc

net-misc/curl:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/curl') }}
    - require:
      - file: gentoo.portage.packages
      {{ libc_pkg_dep() }}
