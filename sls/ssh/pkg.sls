include:
  - core.ldns
  - core.sctp

openssh:
  pkg.installed:
    - pkgs:
      - net-misc/openssh: "=7.2_p2[-hpn,ldns,sctp]"
