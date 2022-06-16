{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

dev-ruby/msgpack:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-ruby/msgpack') }}
    - require:
      - file: gentoo.portage.packages
