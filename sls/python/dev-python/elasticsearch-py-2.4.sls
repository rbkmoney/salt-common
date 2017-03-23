dev-python/elasticsearch-py:
  pkg.installed:
    - pkgs:
      - dev-python/elasticsearch-py: "~>=2.4"
    - require:
      - portage_config: dev-python/elasticsearch-py
  portage_config.flags:
    - name: <dev-python/elasticsearch-py-3.0
    - accept_keywords:
      - "~*"

>=dev-python/elasticsearch-py-3.0:
  portage_config.flags:
    - mask: True
