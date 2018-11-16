include:
  - unbound.pkg

mail-filter/opendkim:
  pkg.installed:
    - version: '>=2.10.3[berkdb,ssl,unbound]'
    - require:
      - pkg: net-dns/unbound
