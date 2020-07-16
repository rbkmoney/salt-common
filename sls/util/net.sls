{% import 'pkg/common' as pkg %}
include:
  - lib.glibc
  - gentoo.portage.packages

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
{% if salt['grains.get']('elibc') != 'musl' %}
      - pkg: sys-libs/glibc
{% endif %}
      - pkg: util-net-purged
      - file: gentoo.portage.packages
    - pkgs:
      - net-analyzer/mtr
      - net-analyzer/tcpdump
      - net-analyzer/traceroute
      - net-analyzer/iftop
      - net-ftp/ftp
      - net-analyzer/openbsd-netcat
      - net-misc/iputils
      - net-misc/rsync
      - net-misc/netkit-telnetd
      - net-misc/wget
      - net-misc/whois
      - sys-apps/iproute2
      - sys-apps/net-tools
      - {{ pkg.gen_atom('net-misc/ipv6calc') }}
      - net-misc/sipcalc
