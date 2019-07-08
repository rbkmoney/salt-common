{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

net-libs/http-parser:
  pkg.latest:
    - oneshot: True
    - require:
      - file: gentoo.portage.packages    
    - pkgs:
      - {{ pkg.gen_atom('net-libs/http-parser') }}
