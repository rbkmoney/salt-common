{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

app-misc/jq:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-misc/jq') }}
    - require:
      - file: gentoo.portage.packages
        
