include:
  - python.dev-python.elasticsearch-py-24

dev-python/elasticsearch-curator:
  pkg.latest:
    - pkgs:
      - dev-python/elasticsearch-curator: "~>=4.2.6"
      - dev-python/elasticsearch-py: "~>=2.4"
    - require:
      - pkg: dev-python/elasticsearch-py
      - portage_config: dev-python/elasticsearch-curator
  portage_config.flags:
    - accept_keywords:
      - "~*"
