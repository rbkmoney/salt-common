{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - python.dev-python.dnspython

dev-python/sleekxmpp:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('dev-python/sleekxmpp') }}
    - require:
      - file: gentoo.portage.packages
      - pkg: dev-python/dnspython
