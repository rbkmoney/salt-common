{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

net-libs/libtirpc:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('net-libs/libtirpc') }}
    - require:
      - file: gentoo.portage.packages
