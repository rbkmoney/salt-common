include:
  - .glibc
  - .nettle

net-libs/gnutls:
  pkg.latest:
    - version: ">=3.6.5[dane]"
    - require:
{% if salt['grains.get']('elibc') != 'musl' %}
      - pkg: sys-libs/glibc
{% endif %}
      - pkg: dev-libs/nettle
