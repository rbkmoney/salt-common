pkg_keepalived:
  pkg.installed:
    - pkgs:
      - sys-cluster/keepalived: '[ipv6,snmp]'
