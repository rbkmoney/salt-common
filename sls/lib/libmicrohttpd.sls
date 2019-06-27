{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

net-libs/libmicrohttpd:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('net-libs/libmicrohttpd') }}
    - require:
      - file: gentoo.portage.packages
