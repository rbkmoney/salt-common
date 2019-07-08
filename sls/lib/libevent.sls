{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-libs/libevent:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('dev-libs/libevent') }}
    - require:
      - file: gentoo.portage.packages
