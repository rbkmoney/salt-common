{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - lib.glibc

util-core:
  pkg.latest:
    - require:
{% if salt['grains.get']('elibc') != 'musl' %}
      - pkg: sys-libs/glibc
{% endif %}
      - file: gentoo.portage.packages
    - pkgs:
      - app-text/tree
      - sys-apps/attr
      - sys-apps/coreutils
      - sys-apps/diffutils
      - sys-apps/elfix
      - sys-apps/file
      - sys-apps/findutils
      - sys-apps/gawk
      - sys-apps/grep
      - sys-apps/kbd
      - sys-apps/less
      - sys-apps/man-pages
      - sys-apps/sed
      - {{ pkg.gen_atom('sys-apps/util-linux') }}
      - sys-apps/which
      - sys-process/atop
      - sys-process/iotop
      - sys-process/lsof
      - sys-process/ftop
      - sys-process/procps
      - sys-process/psmisc
