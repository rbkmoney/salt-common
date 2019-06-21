{% import 'pkg/common' as pkg %}
dev-vcs/git:
  pkg.latest:
    - refresh: false
    - reload_modules: true
    - pkgs:
      - {{ pkg.gen_atom('dev-vcs/git') }}
  {{ pkg.gen_portage_config('dev-vcs/git', watch_in={'pkg': 'dev-vcs/git'})|indent(8) }}
