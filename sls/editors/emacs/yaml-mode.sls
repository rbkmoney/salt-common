{% import 'pkg/common' as pkg %}
include:
  - .pkg

app-emacs/yaml-mode:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-emacs/yaml-mode') }}
    - require: 
      - file: gentoo.portage.packages
      - pkg: app-editors/emacs
