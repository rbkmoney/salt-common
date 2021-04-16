{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

net-misc/chrony:
  pkg.latest:
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('net-misc/chrony') }}

