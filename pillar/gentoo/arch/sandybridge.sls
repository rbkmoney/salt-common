arch_conf:
  CFLAGS: -march=native -O2 -pipe -mfpmath=sse
  CHOST: x86_64-pc-linux-gnu
  CXXFLAGS: ${CFLAGS}
  mirror_arch: amd64/sandybridge
