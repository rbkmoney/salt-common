{% import 'pkg/common' as pkg %}
emacs:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-editors/emacs') }} 
