{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

net-misc/dhcpcd:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('net-misc/dhcpcd') }}
      - {{ pkg.gen_atom('net-dns/openresolv') }}
      {% elif grains.os_family == 'Debian' %}
      - dhcpcd5
      - openresolv
      {% endif %}
    - require:
      {{ libc.pkg_dep() }}
