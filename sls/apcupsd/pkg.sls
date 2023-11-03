{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

sys-power/apcupsd:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('sys-power/apcupsd') }}
      {% elif grains.os_family == 'Debian' %}
      - apcupsd
      {% endif %}
    - require:
      {{ libc.pkg_dep() }}

