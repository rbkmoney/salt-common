# -*- mode: yaml -*-

openssl:
  pkg.installed:
    - refresh: False
    - name: dev-libs/openssl
    - version: "~>=1.0.2d[-bindist,static-libs,tls-heartbeat,zlib]"
    - require:
      - portage_config: sys-libs/zlib
      - portage_config: app-misc/c_rehash

sys-libs/zlib:
  portage_config.flags:
    - use:
      - static-libs
      - minizip

app-misc/c_rehash:
  portage_config.flags:
    - accept_keywords:
      - ~*

