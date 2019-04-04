include:
  - lib.glibc
  - ssl.openssl

net-mail/mailutils:
  pkg.latest:
    - require:
      - pkg: sys-libs/glibc
      - pkg: openssl
