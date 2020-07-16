include:
  - lib.glibc

net-mail/mailutils:
  pkg.latest{% if salt['grains.get']('elibc') != 'musl' %}:
    - require:
      - pkg: sys-libs/glibc
{% endif %}
