{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

net-nds/rpcbind:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-nds/rpcbind') }}
    - require:
      - file: gentoo.portage.packages
