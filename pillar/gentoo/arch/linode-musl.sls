arch_conf:
  CHOST: 'x86_64-gentoo-linux-musl'
  CFLAGS: '-march=corei7-avx -mtune=corei7-avx -O2 -pipe -mfpmath=sse -mno-fma -mno-fma4 -mno-avx2 -mno-xop'
  CXXFLAGS: '${CFLAGS}'
  CPU_FLAGS: 'mmx sse sse2 ssse3 sse4_1 sse4_2 aes popcnt avx'
  mirror_arch: 'musl/amd64/sandybridge'

