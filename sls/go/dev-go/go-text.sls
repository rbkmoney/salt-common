include:
  - go.dev-go.go-tools

dev-go/go-text:
  pkg.installed:
    - pkgs:
      - dev-go/go-text: "~>=0.3.0"
    - require:
      - portage_config: dev-go/go-text
      - pkg: dev-go/go-tools
  portage_config.flags:
    - accept_keywords:
      - "~*"
