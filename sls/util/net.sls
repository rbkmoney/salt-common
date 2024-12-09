{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc
  - .ethtool

util-net-purged:
  pkg.purged:
    - pkgs:
      - net-misc/telnet-bsd
      - www-client/elinks
      - www-client/links
      - net-analyzer/netcat6
      - net-ftp/ftp

util-net:
  pkg.latest:
    - require:
      - file: gentoo.portage.packages
      - pkg: util-net-purged
      {{ libc.pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/mtr') }}
      - {{ pkg.gen_atom('net-analyzer/tcpdump') }}
      - {{ pkg.gen_atom('net-analyzer/traceroute') }}
      - {{ pkg.gen_atom('net-analyzer/iftop') }}
      - {{ pkg.gen_atom('net-ftp/lftp') }}
      - {{ pkg.gen_atom('net-analyzer/openbsd-netcat') }}
      - {{ pkg.gen_atom('net-misc/iputils') }}
      - {{ pkg.gen_atom('net-misc/rsync') }}
      - {{ pkg.gen_atom('net-misc/wget') }}
      - {{ pkg.gen_atom('net-misc/whois') }}
      - {{ pkg.gen_atom('sys-apps/iproute2') }}
      - {{ pkg.gen_atom('sys-apps/net-tools') }}
