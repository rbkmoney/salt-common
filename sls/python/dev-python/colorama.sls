{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-python/colorama:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('dev-python/colorama') }}
    - require:
      - file: gentoo.portage.packages
