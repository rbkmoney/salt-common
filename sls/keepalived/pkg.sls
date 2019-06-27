{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  
pkg_keepalived:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('sys-cluster/keepalived') }}
    - require:
      - file: gentoo.portage.packages
