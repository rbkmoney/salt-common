{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - python.dev-python.dnspython

dev-python/slixmpp:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-python/slixmpp') }}
    - require:
      - file: gentoo.portage.packages
      - pkg: dev-python/dnspython
