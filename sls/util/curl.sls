include:
  - lib.glibc

net-misc/curl:
  pkg.latest:
    - version: "[ssl,adns,-threads]"
    - require:
      - pkg: sys-libs/glibc
