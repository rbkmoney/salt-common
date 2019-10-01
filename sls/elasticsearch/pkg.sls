{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages  
  - java.openjdk-bin11-system

app-misc/elasticsearch:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-misc/elasticsearch') }}
    - require:
      - file: gentoo.portage.packages
