{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

dev-libs/nettle:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('dev-libs/nettle') }}
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}

