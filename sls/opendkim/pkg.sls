include:
  - unbound.pkg

mail-filter/opendkim:
  pkg.latest:
    - version: '[berkdb,ssl,unbound]'
    - require:
      - pkg: net-dns/unbound
