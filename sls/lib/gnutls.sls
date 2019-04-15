include:
  - .glibc
  - .nettle

net-libs/gnutls:
  pkg.latest:
    - version: ">=3.6.5[dane]"
    - require:
      - pkg: sys-libs/glibc
      - pkg: dev-libs/nettle
