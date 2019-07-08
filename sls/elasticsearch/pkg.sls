{% import 'pkg/common' as pkg %}
include:
  - java.icedtea3
  - gentoo.portage.packages  

app-misc/elasticsearch:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-misc/elasticsearch') }}
    - require:
      - file: gentoo.portage.packages
