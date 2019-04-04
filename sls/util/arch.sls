include:
  - lib.glibc

util-arch:
  pkg.latest:
    - require:
      - pkg: sys-libs/glibc
    - pkgs:
      - app-arch/tar
      - app-arch/unzip
      - app-arch/cpio
      - app-arch/libarchive
      - app-arch/gzip
      - app-arch/bzip2
      - app-arch/xz-utils
      - app-arch/lz4
      - app-arch/zstd
