include:
  - go.dev-go.go-sys

dev-go/go-crypto:
  pkg.installed:
    - pkgs:
      - dev-go/go-crypto: "~>=0_pre20180816"
    - require:
      - pkg: dev-go/go-sys
      - portage_config: dev-go/go-crypto
  portage_config.flags:
    - accept_keywords:
      - "~*"
