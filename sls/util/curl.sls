{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - lib.glibc

net-misc/curl:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/curl') }}
    - require:
      - file: gentoo.portage.packages
{% if salt['grains.get']('elibc') != 'musl' %}
      - pkg: sys-libs/glibc
{% endif %}
