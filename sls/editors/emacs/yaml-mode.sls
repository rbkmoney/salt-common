{% import 'pkg/common' as pkg %}
include:
  - .pkg
  - gentoo.portage.packages


app-emacs/yaml-mode:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-emacs/yaml-mode') }}
    - require: 
      - pkg: emacs
      - file: gentoo.portage.packages
