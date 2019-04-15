include:
  - lib.glibc
  - lib.gnutls

net-mail/mailutils:
  pkg.latest:
    - require:
      - pkg: net-libs/gnutls
