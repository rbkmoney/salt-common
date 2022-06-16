{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - python.dev-python.urllib3

dev-python/elasticsearch-py:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-python/elasticsearch-py') }}
    - require:
      - file: gentoo.portage.packages
