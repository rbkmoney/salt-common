include:
  - python.dev-python.click
  - python.dev-python.elasticsearch-py

dev-python/elasticsearch-curator:
  pkg.latest:
    - pkgs:
      - dev-python/elasticsearch-curator: "~>=5.0.4"
      - dev-python/elasticsearch-py: "~>=5.4.0"
    - require:
      - portage_config: dev-python/elasticsearch-curator
  portage_config.flags:
    - accept_keywords:
      - "~*"
