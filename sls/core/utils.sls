utils-purged:
  pkg.purged:
    - pkgs:
      - net-misc/telnet-bsd
      - www-client/elinks
      - www-client/links
      {% if salt['grains.get']('diskless', False) %}
      - sys-apps/hdparm
      - sys-apps/smartmontools
      {% endif %}

util-linux:
  portage_config.flags:
    - name: "sys-apps/util-linux"
    - use:
      - tty-helpers
      - fdformat

# Add mailutils here

utils-latest:
  pkg.latest:
    - require:
      - pkg: utils-purged
      - portage_config: util-linux
    - pkgs:
      - app-arch/bzip2
      - app-arch/gzip
      - app-arch/tar
      - app-arch/xz-utils
      - app-text/tree
      - net-analyzer/mtr
      - net-analyzer/tcpdump
      - net-analyzer/traceroute
      - net-analyzer/iftop
      - net-ftp/ftp
      - net-misc/curl
      - net-misc/iputils
      - net-misc/rsync
      - net-misc/netkit-telnetd
      - net-misc/wget: "~"
      - net-misc/whois 
      - sys-apps/attr
      - sys-apps/coreutils
      - sys-apps/diffutils
      - sys-apps/elfix
      - sys-apps/file
      - sys-apps/findutils
      - sys-apps/gawk
      - sys-apps/grep
      - sys-apps/iproute2
      - sys-apps/kbd
      - sys-apps/less
      - sys-apps/man-pages
      - sys-apps/net-tools
      - sys-apps/sed
      - sys-apps/util-linux: "[tty-helpers,fdformat]"
      - sys-apps/which
      - sys-process/atop: "~>=2.2"
      - sys-process/iotop
      - sys-process/lsof
      - sys-process/ftop
      - sys-process/procps
      - sys-process/psmisc
      - app-misc/screen
      - app-shells/zsh
      - app-doc/zsh-lovers
      - app-shells/gentoo-zsh-completions
      - app-admin/killproc
      - sys-devel/bc
      {% if not salt['grains.get']('diskless', False) %}
      - sys-fs/e2fsprogs
      - sys-fs/xfsprogs
      - sys-apps/hdparm
      - sys-apps/smartmontools
      {% endif %}
      {% if salt['grains.get']('fibrechannel', False)
      or salt['grains.get']('iscsi', False)
      or salt['grains.get']('scsi', False) %}
      - sys-apps/sg3_utils
      - sys-apps/rescan-scsi-bus
      {% endif %}
