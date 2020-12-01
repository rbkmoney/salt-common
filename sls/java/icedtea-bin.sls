{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - java.common

dev-java/icedtea-bin:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-java/icedtea-bin') }}
