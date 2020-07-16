{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - .glibc  

dev-libs/nettle:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('dev-libs/nettle') }}
    - require:
      - file: gentoo.portage.packages
{% if salt['grains.get']('elibc') != 'musl' %}
      - pkg: sys-libs/glibc      
{% endif %}
