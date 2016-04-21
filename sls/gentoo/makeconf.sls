# -*- mode: yaml -*-
include:
  - augeas.lenses
{% set mirror_host = salt['pillar.get']('gentoo_mirror_host', 'gentoo.bakka.su') %}
{% set make_conf = salt['pillar.get']('make_conf', False) %}
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
      - set PORT_LOGDIR '"/var/log/portage"'
      {% if make_conf %}
      - set PORTAGE_SSH_OPTS '"{{ make_conf.get("portage_ssh_opts", '') }}"'
      {% if make_conf.get('makeopts', False) %}
      - set MAKEOPTS '"{{ make_conf["makeopts"] }}"'
      {% else %}
      - set MAKEOPTS '"-j{{ num_jobs }} --load-average {{ max_la }}"'
      {% endif %}
      - set FEATURES '"{{ make_conf.get("features", "xattr sandbox userfetch parallel-fetch parallel-install clean-logs compress-build-logs unmerge-logs splitdebug compressdebug fail-clean unmerge-orphans getbinpkg -news") }}"'
      - set EMERGE_DEFAULT_OPTS '"{{ make_conf.get("emerge_default_opts", "--quiet-build --verbose --keep-going") }}"'
      - set VIDEO_CARDS '"{{ make_conf.get("video_cards", "") }}"'
      - set LANG '"{{ make_conf.get("lang", "en") }}"'
      {% if make_conf.get("other", False) %}
      {% for k, v in make_conf["other"] %}
      - set {{ k }} '"{{ v }}"'
      {% endfor %}
      {% endif %}
      {% endif %}
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
      - rm AUTOCLEAN
    - require:
      - file: /usr/share/augeas/lenses/makeconf.aug


