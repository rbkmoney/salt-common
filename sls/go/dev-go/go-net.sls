include:
  - go.dev-go.go-sys
  - go.dev-go.go-text
  - go.dev-go.go-crypto

dev-go/go-net:
  pkg.installed:
    version: "~>=0_pre20180816"
    - require:
      - portage_config: dev-go/go-net
      - pkg: dev-go/go-sys
      - pkg: dev-go/go-text
      - pkg: dev-go/go-crypto
  portage_config.flags:
    - accept_keywords:
      - "~*"
