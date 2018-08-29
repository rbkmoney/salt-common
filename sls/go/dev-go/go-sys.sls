dev-go/go-sys:
  pkg.installed:
    - version: "~>=0_pre20180816"
    - require:
      - portage_config: dev-go/go-sys
  portage_config.flags:
    - accept_keywords:
      - "~*"
