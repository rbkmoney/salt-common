
openssl:
  pkg.installed:
    - refresh: False
    - pkgs:
      - dev-libs/openssl: "~>=1.0.2k[-bindist,sctp,static-libs,tls-heartbeat,zlib]"
      - sys-libs/zlib: ">=1.2.11[static-libs,minizip]"
    - require:
      - portage_config: app-misc/c_rehash
