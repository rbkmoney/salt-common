{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

net-libs/nodejs:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('net-libs/nodejs') }}
    - require:
      - file: gentoo.portage.packages
