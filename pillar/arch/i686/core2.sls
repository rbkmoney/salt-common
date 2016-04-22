arch_conf:
  mirror_arch: 'i686/core2'
  CHOST: 'i686-pc-linux-gnu'
  CFLAGS: '-march=native -O2 -pipe -mfpmath=sse'
  CXXFLAGS: '${CFLAGS}'
