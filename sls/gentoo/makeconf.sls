#!pydsl
# -*- mode: python -*-
include("augeas.lenses")
mirror_host = __salt__['pillar.get']('gentoo:mirror-host', 'gentoo-mirror.bakka.su')
make_conf = __salt__['pillar.get']('make_conf', False)
arch_conf = __salt__['pillar.get']('arch_conf', False)

num_jobs = __grains__['num_cpus']
max_la = "%.2f" % (__grains__['num_cpus'] / 1.5)
if num_jobs > 8:
  num_jobs = 8

changes = [
  'set PORTDIR \'"/usr/portage"\'',
  'set DISTDIR \'"/var/tmp/distfiles"\'',
  'set PKGDIR \'"/var/tmp/packages"\'',
  'set PORT_LOGDIR \'"/var/log/portage"\'',
  'set GENTOO_MIRRORS \'"https://' + mirror_host + '/gentoo-distfiles"\'',
  'rm AUTOCLEAN',
]
def chap(key, value):
  changes.append('set ' + key + ' \'"' + value + '"\'')

default_features = ["xattr sandbox userfetch parallel-fetch parallel-install clean-logs",
                    "compress-build-logs unmerge-logs splitdebug compressdebug fail-clean",
                    "unmerge-orphans getbinpkg -news"]
emerge_default_opts = '--quiet-build --verbose --keep-going'
default_makeopts = ('-j'+str(num_jobs)+' --load-average '+str(max_la))

if make_conf:
  chap('MAKEOPTS', make_conf.get('makeopts', default_makeopts))
  chap('FEATURES', ' '.join(make_conf.get('features', default_features)))
  chap('EMERGE_DEFAULT_OPTS', make_conf.get('emerge_default_opts', emerge_default_opts))
  if make_conf.get('other', {'USE_SALT': ''}):
    for k, v in make_conf['other'].items():
      chap(k, v)
else:
  chap('MAKEOPTS', default_makeopts)
  chap('FEATURES', ' '.join(default_features))
  chap('EMERGE_DEFAULT_OPTS', emerge_default_opts)
  chap('USE_SALT', '')

if arch_conf:
  chap('CHOST', arch_conf['CHOST'])
  chap('CFLAGS', arch_conf['CFLAGS'])
  chap('CXXFLAGS', arch_conf.get('CXXFLAGS', '${CFLAGS}'))
  # Should I also check for osarch here?
  if (__grains__['cpuarch'] == 'x86_64' or __grains__['cpuarch'] == 'amd64'
      or __grains__['cpuarch'] == 'i686' or __grains__['cpuarch'] == 'x86'):
    if arch_conf.get('CPU_FLAGS', False):
      chap('CPU_FLAGS_X86', arch_conf['CPU_FLAGS'])
    else:
      chap('CPU_FLAGS_X86', ' '.join(filter(
        lambda x: x in __grains__['cpu_flags'],
        ('mmx', 'mmxext', 'sse', 'sse2', 'sse3', 'ssse3', 'sse4_1', 'sse4_2',
         'aes', 'popcnt', 'avx', 'avx2', 'fma', 'fma3', 'fma4', 'xop', '3dnow',
         '3dnowext', 'sse4a'))))
  if arch_conf.get('mirror_arch', False):
    binhost = arch_conf.get('binhost-host', mirror_host)
    chap('PORTAGE_BINHOST',
         'https://' + binhost + '/gentoo-packages/' + arch_conf['mirror_arch'] + '/packages')

state('manage-make-conf').augeas.change(
  context='/files/etc/portage/make.conf',
  # - lens: Makeconf.lns,
  changes=changes).require(file='/usr/share/augeas/lenses/makeconf.aug')
