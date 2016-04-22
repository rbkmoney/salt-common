arch_conf:
  mirror_arch: 'armv6j/hardfloat'
  CHOST: 'armv6j-hardfloat-linux-gnueabi'
  CFLAGS: '-O2 -pipe -march=armv6j -mfpu=vfp -mfloat-abi=hard'
  CXXFLAGS: '${CFLAGS}'
