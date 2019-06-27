{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-libs/libuv:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('dev-libs/libuv') }}
    - require:
      - file: gentoo.portage.packages
