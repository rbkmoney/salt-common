{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - python.dev-python.elasticsearch-py

dev-python/elasticsearch-curator:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-python/elasticsearch-curator') }}
    - require:
      - file: gentoo.portage.packages
      - pkg: dev-python/elasticsearch-py
