include:
  - lib.glibc
  - lib.ldns
  - lib.libevent
  - lib.libsodium

net-dns/unbound:
  pkg.installed:
    - version: "~>=1.9.0[dnscrypt,ecdsa]"
