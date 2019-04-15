include:
  - lib.glibc
  - ssl.openssl

net-mail/mailutils:
  pkg.latest:
    - require:
      - pkg: net-libs/gnutls
