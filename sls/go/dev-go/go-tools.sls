include:
  - go.dev-go.go-crypto

dev-go/go-tools:
  pkg.installed:
    - version: "~>=0_pre20180817"
    - require:
      - portage_config: dev-go/go-tools
      - pkg: dev-go/go-crypto
  portage_config.flags:
    - accept_keywords:
      - "~*"
