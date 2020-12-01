{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

util-shell:
  pkg.latest:
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('app-shells/bash') }}
      - {{ pkg.gen_atom('app-shells/bash-completion') }}
      - {{ pkg.gen_atom('sys-apps/miscfiles') }}
      - {{ pkg.gen_atom('app-shells/zsh') }}
      - {{ pkg.gen_atom('app-doc/zsh-lovers') }}
      - {{ pkg.gen_atom('app-misc/screen') }}
      - {{ pkg.gen_atom('app-admin/killproc') }}
      - {{ pkg.gen_atom('sys-devel/bc') }}
