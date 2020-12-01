{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - .nettle
  {% if grains['elibc'] == 'glibc' %}
  - .glibc
  {% endif %}

net-libs/gnutls:
  pkg.latest:
    - oneshot: True
    - require:
      - file: gentoo.portage.packages
      - pkg: dev-libs/nettle
      {% if grains['elibc'] == 'glibc' %}
      - pkg: sys-libs/glibc
      {% endif %}
    - pkgs:
      - {{ pkg.gen_atom('net-libs/gnutls') }}
