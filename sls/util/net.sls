include:
  - lib.glibc

util-net-purged:
  pkg.purged:
    - pkgs:
      - net-misc/telnet-bsd
      - www-client/elinks
      - www-client/links
      - net-analyzer/netcat6

util-net:
  pkg.latest:
    - require:
      - pkg: sys-libs/glibc
      - pkg: util-net-purged
    - pkgs:
      - net-analyzer/mtr
      - net-analyzer/tcpdump
      - net-analyzer/traceroute
      - net-analyzer/iftop
      - net-ftp/ftp
      - net-analyzer/netcat
      - net-misc/iputils
      - net-misc/rsync
      - net-misc/netkit-telnetd
      - net-misc/wget: "~"
      - net-misc/whois
      - sys-apps/iproute2
      - sys-apps/net-tools
      - net-misc/ipv6calc: "~"
      - net-misc/sipcalc
