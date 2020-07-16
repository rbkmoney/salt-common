{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - lib.glibc

net-dns/unbound:
  pkg.installed:
    - require:
      - file: gentoo.portage.packages
{% if salt['grains.get']('elibc') != 'musl' %}
      - pkg: sys-libs/glibc
{% endif %}
    - pkgs:
      - {{ pkg.gen_atom('net-dns/unbound') }}
