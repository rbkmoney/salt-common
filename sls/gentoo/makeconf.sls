# -*- mode: yaml -*-
include:
  - augeas.lenses
{% set mirror_host = salt['pillar.get']('gentoo_mirror_host', 'gentoo.bakka.su') %}
{% set arch_conf = salt['pillar.get']('arch_conf', False) %}

{% set num_jobs = grains['num_cpus'] %}
{% set max_la = "%.2f" % (grains['num_cpus'] / 1.5) %}
{% if num_jobs > 8 %}
  {% set num_jobs = 8 %}
{% endif %}

manage-make-conf:
  augeas.change:
    - context: /files/etc/portage/make.conf
    # - lens: Makeconf.lns
    - changes:
      - set PORTDIR '"/usr/portage"'
      - set DISTDIR '"/var/tmp/distfiles"'
      - set PKGDIR '"/var/tmp/packages"'
      - set PORTAGE_SSH_OPTS '""'
      - set MAKEOPTS '"-j{{ num_jobs }} --load-average {{ max_la }}"'
      - set PYTHON_TARGETS '"python2_7 python3_4"'
      - set USE_PYTHON '"2.7 3.4"'
      - set USE_SALT '"smp multitarget efi icu sqlite emacs sctp xattr syslog logrotate ssl openssl vhosts symlink device-mapper bash-completion zsh-completion -gnutls -tcpd"'
      - set VIDEO_CARDS '""'
      - set GENTOO_MIRRORS '"https://{{ mirror_host }}/gentoo-distfiles"'
      {% if arch_conf %}
      - set CHOST '"{{ arch_conf["CHOST"] }}"'
      - set CFLAGS '"{{ arch_conf["CFLAGS"] }}"' 
      {% if arch_conf.get('CXXFLAGS', False) %}
      {% set l_cxxflags = arch_conf['CXXFLAGS'] %}
      {% else %}
      {% set l_cxxflags = '${CFLAGS}' %}
      {% endif %}
      - set CXXFLAGS '"{{ l_cxxflags }}"'
      # Should I also check for osarch here?
      {% if (grains['cpuarch'] == 'x86_64' or grains['cpuarch'] == 'amd64'
      or grains['cpuarch'] == 'i686' or grains['cpuarch'] == 'x86') %}
      {% if arch_conf.get('CPU_FLAGS', False) %}
      - set CPU_FLAGS_X86 '"{{ arch_conf["CPU_FLAGS"] }}"'
      {% else %}
      - set CPU_FLAGS_X86 '"{% for flag in ("mmx", "mmxext", "sse", "sse2", "sse3", "ssse3", "sse4_1", "sse4_2",
      "aes", "popcnt", "avx", "avx2", "fma", "fma3", "fma4", "xop", "3dnow", "3dnowext", "sse4a")
      %}{% if flag in grains["cpu_flags"] %}{{ flag }}{% if not loop.last %} {% endif %}{% endif %}{% endfor %}"'
      {% endif %}
      {% endif %}
      {% if arch_conf.get('mirror_arch', False) %}
      - set PORTAGE_BINHOST '"https://{{ mirror_host }}/gentoo-packages/{{ arch_conf["mirror_arch"] }}/packages"'
      {% endif %}
      {% endif %}
    - require:
      - file: /usr/share/augeas/lenses/makeconf.aug
