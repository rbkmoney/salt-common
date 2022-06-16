{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-python/python-gnupg:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-python/python-gnupg') }}
    - require:
      - file: gentoo.portage.packages
