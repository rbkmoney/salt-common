pkg_opendkim:
  pkg.latest:
    - pkgs:
        - mail-filter/opendkim: '[berkdb,ssl,unbound]'
        - net-dns/unbound
