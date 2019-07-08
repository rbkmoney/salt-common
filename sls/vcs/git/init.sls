{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-vcs/git:
  pkg.latest:
    - reload_modules: true
    - pkgs:
      - {{ pkg.gen_atom('dev-vcs/git') }}
    - require:
      - file: gentoo.portage.packages
