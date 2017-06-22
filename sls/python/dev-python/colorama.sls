colorama:
  pkg.installed:
    - require:
      - portage_config: colorama
  portage_config.flags:
    - name: dev-python/colorama
    - accept_keywords:
      - "~*"
