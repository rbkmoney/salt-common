{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

lksctp-tools:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/lksctp-tools') }}
    - require:
      - file: gentoo.portage.packages
