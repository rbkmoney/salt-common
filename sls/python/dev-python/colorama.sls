dev-python/colorama:
  pkg.installed:
    - require:
      - portage_config: dev-python/colorama
  portage_config.flags:
    - accept_keywords:
      - "~*"
