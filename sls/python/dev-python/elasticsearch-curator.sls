# TODO: refactor
include:
  - python.dev-python.click
  - python.dev-python.elasticsearch-py

dev-python/elasticsearch-curator:
  pkg.latest:
    - pkgs:
      - dev-python/elasticsearch-curator: "~>=5.6.0"
      - dev-python/elasticsearch-py: ">=6.3.1-r1"
      - dev-python/certifi: "~>=2018.10.15"
    - require:
      - portage_config: dev-python/elasticsearch-curator
  portage_config.flags:
    - accept_keywords:
      - "~*"
