include:
  - core.ldns
  - core.sctp

openssh:
  pkg.installed:
    - pkgs:
      - net-misc/openssh: "~=7.1_p2[hpn,ldns,sctp]"
