{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

net-misc/curl:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/curl') }}
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
