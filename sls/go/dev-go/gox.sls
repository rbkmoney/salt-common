dev-go/gox:
  pkg.latest:
    - require:
      - portage_config: dev-go/gox
  portage_config.flags:
    - accept_keywords:
      - "~*"
