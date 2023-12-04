{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

nagios_pkg:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('net-analyzer/nagios-core') }}
      {% elif grains.os_family == 'Debian' %}
      - nagios4-core
      {% endif %}
    - require:
      {{ libc.pkg_dep() }}
