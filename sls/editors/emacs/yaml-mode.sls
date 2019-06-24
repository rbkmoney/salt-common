{% import 'pkg/common' as pkg %}
include:
  - .pkg

app-emacs/yaml-mode:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-emacs/yaml-mode') }}
    - require: 
      - pkg: emacs
  {{ pkg.gen_portage_config('app-emacs/yaml-mode', watch_in={'pkg': 'app-emacs/yaml-mode'})|indent(8) }}
