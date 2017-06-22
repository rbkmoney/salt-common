dev-python/urllib3:
  pkg.latest:
    - require:
      - portage_config: dev-python/urllib3
  portage_config.flags:
    - accept_keywords:
      - "~*"
