include:
  - core.gcc
  - core.binutils

'emerge -q --prune sys-devel/gcc':
  cmd.run:
    - onchanges:
      - pkg: sys-devel/gcc
      - cmd: set-gcc-profile

'emerge -q --prune sys-devel/binutils sys-libs/binutils-libs':
  cmd.run:
    - onchanges:
      - pkg: sys-devel/binutils
      - eselect: eselect-binutils
      - cmd: eselect-binutils
