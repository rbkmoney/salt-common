include:
  - lib.glibc

net-mail/mailutils:
  pkg.latest:
    - require:
      - pkg: sys-libs/glibc
