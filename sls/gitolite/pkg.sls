{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-vcs/gitolite:
  pkg.installed:
    - require:
      - file: gentoo.portage.packages
    - pkgs:
      - {{ pkg.gen_atom('dev-vcs/gitolite') }}

