{% import 'pkg/common' as pkg %}
include:
  - .pkg

app-emacs/yaml-mode:
  pkg.latest
  {{ pkg.gen_portage_config('app-emacs/yaml-mode', watch_in={'pkg': 'app-emacs/yaml-mode'})|indent(8) }}
