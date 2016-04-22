arch_conf:
  mirror_arch: 'amd64/corei7-avx'
  CHOST: 'x86_64-pc-linux-gnu'
  CFLAGS: '-march=native -O2 -pipe -mfpmath=sse'
  CXXFLAGS: '${CFLAGS}'
