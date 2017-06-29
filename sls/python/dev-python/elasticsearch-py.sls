include:
  - python.dev-python.urllib3

dev-python/elasticsearch-py:
  pkg.latest:
    - pkgs:
      - dev-python/elasticsearch-py: "~>=5.4.0"
    - require:
      - portage_config: dev-python/elasticsearch-py
  portage_config.flags:
    - name: ">=dev-python/elasticsearch-py-5.4.0"
    - accept_keywords:
      - "~*"
