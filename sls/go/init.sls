{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-lang/go:
  pkg.latest:
    - require:
      - file: gentoo.portage.packages        
    - pkgs:
      - {{ pkg.gen_atom('dev-lang/go') }}
