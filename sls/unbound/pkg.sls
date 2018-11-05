include:
  - lib.glibc
  - ssl.openssl
  - lib.ldns
  - lib.libevent
  - lib.libsodium

net-dns/unbound:
  pkg.installed:
    - version: "~>=1.6.8-r2[dnscrypt,ecdsa]"
