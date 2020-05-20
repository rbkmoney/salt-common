{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - java.common

dev-java/openjdk-bin:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('dev-java/openjdk-bin') }}
    - require:
      - file: gentoo.portage.packages
