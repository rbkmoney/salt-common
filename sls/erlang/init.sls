{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-lang/erlang:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('dev-lang/erlang') }}
    - require:
      - file: gentoo.portage.packages
