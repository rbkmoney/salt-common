arch_conf:
  CHOST: 'x86_64-pc-linux-gnu'
  CFLAGS: '-march=haswell -mtune=haswell -O2 -pipe -mfpmath=sse -mno-fma -mno-fma4 -mno-avx2 -mno-xop'
  CXXFLAGS: '${CFLAGS}'
  CPU_FLAGS: 'mmx mmxext sse sse2 sse3 ssse3 sse4 sse4_1 sse4_2 aes popcnt avx'
  mirror_arch: 'amd64/haswell'
