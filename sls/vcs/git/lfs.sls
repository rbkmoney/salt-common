include:
  - vcs.git
  - go

dev-vcs/git-lfs:
  portage_config.flags:
    - accept_keywords:
      - ~*
  pkg.latest:
    - require:
      - pkg: dev-lang/go
      - portage_config: dev-vcs/git-lfs
