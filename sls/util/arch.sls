{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

util-arch:
  pkg.latest:
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('app-arch/tar') }}
      - {{ pkg.gen_atom('app-arch/unzip') }}
      - {{ pkg.gen_atom('app-arch/cpio') }}
      - {{ pkg.gen_atom('app-arch/libarchive') }}
      - {{ pkg.gen_atom('app-arch/gzip') }}
      - {{ pkg.gen_atom('app-arch/bzip2') }}
      - {{ pkg.gen_atom('app-arch/xz-utils') }}
      - {{ pkg.gen_atom('app-arch/lz4') }}
      - {{ pkg.gen_atom('app-arch/zstd') }}
