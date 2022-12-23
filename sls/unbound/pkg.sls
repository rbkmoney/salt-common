{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

net-dns/unbound:
  pkg.installed:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('net-dns/unbound') }}
      {% elif grains.os_family == 'Debian' %}
      - unbound
      - unbound-anchor
      - unbound-host
      {% endif %}
    - require:
      {{ libc.pkg_dep() }}
