{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

app-editors/emacs:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-editors/emacs') }} 
    - require:
      - file: gentoo.portage.packages
