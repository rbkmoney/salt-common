arch_conf:
  # There's no corei7-avx2 buildhost yet.
  mirror_arch: 'amd64/corei7-avx'
  CHOST: 'x86_64-pc-linux-gnu'
  CFLAGS: '-march=native -O2 -pipe -mfpmath=sse'
  CPU_FLAGS: 'mmx mmxext sse sse2 sse3 ssse3 sse4 sse4_1 sse4_2 aes avx avx2'
