{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-python/urllib3:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-python/urllib3') }}
    - require:
      - file: gentoo.portage.packages

