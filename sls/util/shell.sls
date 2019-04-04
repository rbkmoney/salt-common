include:
  - lib.glibc

util-shell:
  pkg.latest:
    - require:
      - pkg: sys-libs/glibc
    - pkgs:
      - app-shells/bash
      - app-shells/bash-completion
      - sys-apps/miscfiles
      - app-shells/zsh
      - app-doc/zsh-lovers
      - app-misc/screen
      - app-admin/killproc
      - sys-devel/bc
