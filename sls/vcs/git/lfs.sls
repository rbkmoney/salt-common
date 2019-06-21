{% import 'pkg/common' as pkg %}
include:
  - vcs.git

dev-vcs/git-lfs:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-vcs/git-lfs') }}
  {{ pkg.gen_portage_config('dev-vcs/git-lfs', watch_in={'pkg': 'dev-vcs/git-lfs'})|indent(8) }}
