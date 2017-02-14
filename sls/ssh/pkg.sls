include:
  - lib.ldns
  - lib.sctp

openssh:
  pkg.installed:
    - pkgs:
      - net-misc/openssh: ">=7.3_p1[hpn,ldns,sctp]"
