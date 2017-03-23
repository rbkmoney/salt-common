dev-python/elasticsearch-py:
  pkg.latest:
    - pkgs:
      - dev-python/elasticsearch-py: "~>=5.2.0"
    - require:
      - portage_config: dev-python/elasticsearch-py
  portage_config.flags:
    - name: >=dev-python/elasticsearch-py-5.2.0
    - accept_keywords:
      - "~*"

>=dev-python/elasticsearch-py-3.0:
  portage_config.flags:
    - mask: False
