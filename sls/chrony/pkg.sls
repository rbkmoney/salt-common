{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

net-misc/chrony:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('net-misc/chrony') }}
      {% elif grains.os_family == 'Debian' %}
      - chrony
      {% endif %}
    - require:
      {% if grains.os == 'Gentoo' %}
      - file: gentoo.portage.packages
      {% endif %}
      {{ libc.pkg_dep() }}

