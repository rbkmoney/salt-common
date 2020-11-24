{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

util-core:
  pkg.latest:
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('app-text/tree') }}
      - {{ pkg.gen_atom('sys-apps/attr') }}
      - {{ pkg.gen_atom('sys-apps/coreutils') }}
      - {{ pkg.gen_atom('sys-apps/diffutils') }}
      - {{ pkg.gen_atom('sys-apps/elfix') }}
      - {{ pkg.gen_atom('sys-apps/file') }}
      - {{ pkg.gen_atom('sys-apps/findutils') }}
      - {{ pkg.gen_atom('sys-apps/gawk') }}
      - {{ pkg.gen_atom('sys-apps/grep') }}
      - {{ pkg.gen_atom('sys-apps/kbd') }}
      - {{ pkg.gen_atom('sys-apps/less') }}
      - {{ pkg.gen_atom('sys-apps/man-pages') }}
      - {{ pkg.gen_atom('sys-apps/sed') }}
      - {{ pkg.gen_atom('sys-apps/util-linux') }}
      - {{ pkg.gen_atom('sys-apps/which') }}
      - {{ pkg.gen_atom('sys-process/atop') }}
      - {{ pkg.gen_atom('sys-process/iotop') }}
      - {{ pkg.gen_atom('sys-process/lsof') }}
      - {{ pkg.gen_atom('sys-process/ftop') }}
      - {{ pkg.gen_atom('sys-process/procps') }}
      - {{ pkg.gen_atom('sys-process/psmisc') }}
