#!pyobjects
# -*- mode: python -*-
include("augeas.lenses")
mirror_host = grains('gentoo:mirror-host', 'gentoo.bakka.su')
make_conf = pillar('make_conf', {})
arch_conf = pillar('arch_conf', {})

num_jobs = grains('num_cpus')
max_la = "%.2f" % (grains('num_cpus') / 1.5)
if num_jobs > 8:
  num_jobs = 8

changes = [
  'rm AUTOCLEAN',
]


def chap(key, value):
  '''Changes append'''
  changes.append('set ' + key + ' \'"' + value + '"\'')


default_features = [
  "xattr sandbox userfetch parallel-fetch parallel-install",
  "clean-logs compress-build-logs unmerge-logs",
  "splitdebug compressdebug fail-clean",
  "unmerge-orphans getbinpkg -news"]

DISTDIR = make_conf.get('distdir', '/var/cache/distfiles')
chap('DISTDIR', DISTDIR)
File.directory(DISTDIR, create=True, mode=775,
               user='root', group='portage')
PKGDIR = make_conf.get('pkgdir', '/var/cache/binpkgs')
chap('PKGDIR', PKGDIR)
File.directory(PKGDIR, create=True, mode=775,
               user='root', group='portage')

chap('GENTOO_MIRRORS',
     make_conf.get('gentoo_mirrors',
                   'https://' + mirror_host + '/gentoo-distfiles'))

chap('EMERGE_DEFAULT_OPTS',
     make_conf.get('emerge_default_opts',
                   '--quiet-build --verbose --keep-going'))
chap('MAKEOPTS',
     make_conf.get('makeopts',
                   ('-j' + str(num_jobs)
                    + ' --load-average ' + str(max_la))))
chap('FEATURES',
     ' '.join(make_conf.get('features', default_features)))

for k, v in make_conf.get('other', {'USE_SALT': ''}).items():
    chap(k, v)

cpu_flags = grains('cpu_flags')
cpuarch = grains('cpuarch')
# Should I also check for osarch here?
if (cpuarch == 'x86_64' or cpuarch == 'amd64'
    or cpuarch == 'i686' or cpuarch == 'x86'):
  cpu_flags_map = {
    'mmx': '', 'mmxext': '', 'sse': 'sse mmxext',
    'sse2': '', 'pni': 'sse3', 'ssse3': '',
    'sse4_1': '', 'sse4_2': '', 'popcnt': '',
    'avx': '', 'avx2': '', 'fma': 'fma3', 'fma4': '',
    'aes': '',
    '3dnow': '', '3dnowext': '', 'sse4a': '', 'xop': ''}
  cpu_flags_var = 'CPU_FLAGS_X86'
elif cpuarch.startswith('arm'):
  cpu_flags_map = {}
  cpu_flags_var = 'CPU_FLAGS_ARM'
else:
  cpu_flags_var = False

if cpu_flags_var:
  if arch_conf and arch_conf.get('CPU_FLAGS', False):
    chap(cpu_flags_var, arch_conf['CPU_FLAGS'])
  else:
    if arch_conf and 'cpu-flags-map' in arch_conf:
      cpu_flags_map = arch_conf['cpu-flags-map']
    chap(cpu_flags_var, ' '.join(
      [cpu_flags_map[flag] if cpu_flags_map[flag] else flag
       for flag in cpu_flags_map.keys() if flag in cpu_flags]))

if arch_conf:
  chap('CHOST', arch_conf['CHOST'])
  chap('CFLAGS', arch_conf['CFLAGS'])
  chap('CXXFLAGS', arch_conf.get('CXXFLAGS', '${CFLAGS}'))
  if arch_conf.get('mirror_arch', False):
    binhost = arch_conf.get('binhost-host', mirror_host)
    chap('PORTAGE_BINHOST',
         arch_conf.get('portage_binhost',
                       'https://' + binhost + '/gentoo-packages/'
                       + arch_conf['mirror_arch'] + '/packages'))

Augeas.change('manage-make-conf',
  context='/files/etc/portage/make.conf',
  # - lens: Makeconf.lns,
  changes=changes,
  require=[File('/usr/share/augeas/lenses/makeconf.aug')])
