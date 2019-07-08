{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-libs/libsodium:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('dev-libs/libsodium') }}
    - require:
      - file: gentoo.portage.packages
