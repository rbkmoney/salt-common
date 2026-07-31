{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

app-misc/yq:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-misc/yq-go') }}
    - require:
      - file: gentoo.portage.packages
