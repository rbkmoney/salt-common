include:
  - .glibc

dev-libs/nettle:
  pkg.latest:
    - require:
      - pkg: sys-libs/glibc
