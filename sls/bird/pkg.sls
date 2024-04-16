{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

pkg_bird:
  pkg.installed:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('net-misc/bird') }}
      {% elif grains.os_family == 'Debian' %}
      - bird2
      {% endif %}
    - require:
      {{ libc.pkg_dep() }}
