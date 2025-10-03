{% set cpuarch = grains.get('cpuarch', '') %}
{% set cpu_flags = grains.get('cpu_flags', '') %}

arch_conf:
{% if cpuarch == 'x86_64' %}
  CHOST: x86_64-pc-linux-gnu
  CFLAGS: '-march=native -O2 -pipe -mfpmath=sse'
  CXXFLAGS: '${CFLAGS}'
{% if 'avx2' in cpu_flags %}
  mirror_arch: 'amd64/haswell'
{% elif 'avx' in cpu_flags %}
  mirror_arch: 'amd64/corei7-avx'
{% elif 'sse4_2' in cpu_flags %}
  mirror_arch: 'amd64/corei7'
{% else %}
  mirror_arch: 'amd64/core2'
{% endif %}
{% elif cpuarch == 'i686' %}
  CHOST: i686-pc-linux-gnu
  CFLAGS: '-march=native -O2 -pipe -mfpmath=sse'
  CXXFLAGS: '${CFLAGS}'
  mirror_arch: 'i686/core2'
{% elif cpuarch.startswith('arm') %}
  CHOST: armv6j-hardfloat-linux-gnueabi
  CFLAGS: '-O2 -pipe -march=armv6j -mfpu=vfp -mfloat-abi=hard'
  CXXFLAGS: '${CFLAGS}'
  mirror_arch: 'armv6j/hardfloat'
{% endif %}
