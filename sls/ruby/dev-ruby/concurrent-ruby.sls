{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-ruby/concurrent-ruby:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-ruby/concurrent-ruby') }}
    - require:
      - file: gentoo.portage.packages
