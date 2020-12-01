{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  {% if grains['elibc'] == 'glibc' %}
  - .glibc  
  {% endif %}

dev-libs/nettle:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('dev-libs/nettle') }}
    - require:
      - file: gentoo.portage.packages
      {% if grains['elibc'] == 'glibc' %}
      - pkg: sys-libs/glibc      
      {% endif %}
