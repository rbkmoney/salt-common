{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

pkg_bird:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/bird') }}
    - require:
      - file: gentoo.portage.packages
