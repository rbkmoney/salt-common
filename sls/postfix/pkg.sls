{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

mail-mta/postfix:
  pkg.installed:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('mail-mta/postfix') }}
      {% elif grains.os_family == 'Debian' %}
      - postfix
      - postfix-pcre
      - postfix-cdb
      - postfix-mysql
      {% endif %}
    - require:
      {{ libc.pkg_dep() }}
