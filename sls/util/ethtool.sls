{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

sys-apps/ethtool:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('sys-apps/ethtool') }}
      {% elif grains.os_family == 'Debian' %}
      - ethtool
      {% endif %}
    - require:
      {{ libc.pkg_dep() }}
