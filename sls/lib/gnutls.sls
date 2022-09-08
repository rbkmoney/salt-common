{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc
  - .nettle

net-libs/gnutls:
  pkg.latest:
    - oneshot: True
    - require:
      - pkg: dev-libs/nettle
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('net-libs/gnutls') }}
