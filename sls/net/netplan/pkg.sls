{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

net-misc/netplan:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/netplan') }}
    - require:
      - file: gentoo.portage.packages
