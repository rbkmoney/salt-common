include:
  - lib.glibc

util-shell:
  pkg.latest:
{% if salt['grains.get']('elibc') != 'musl' %}
    - require:
      - pkg: sys-libs/glibc
{% endif %}
    - pkgs:
      - app-shells/bash
      - app-shells/bash-completion
      - sys-apps/miscfiles
      - app-shells/zsh
      - app-doc/zsh-lovers
      - app-misc/screen
      - app-admin/killproc
      - sys-devel/bc
