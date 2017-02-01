colorama:
  pkg.installed:
    - pkgs:
      - dev-python/colorama: "0.3.7"
    - require:
      - portage_config: colorama
  portage_config.flags:
    - name: dev-python/colorama
    - accept_keywords:
      - "~*"
