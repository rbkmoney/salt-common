{% import 'pkg/common' as pkg %}
include:
  - vcs.git
  - gentoo.portage.packages  

dev-vcs/git-lfs:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-vcs/git-lfs') }}
    - require:
      - file: gentoo.portage.packages
