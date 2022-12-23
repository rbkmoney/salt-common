{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc
  - unbound.pkg

mail-filter/opendkim:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('mail-filter/opendkim') }}
      {% elif grains.os_family == 'Debian' %}
      - opendkim
      - opendkim-tools
      {% endif %}
    - require:
      - pkg: net-dns/unbound      
      {{ libc.pkg_dep() }}
