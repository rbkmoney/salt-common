{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

net-analyzer/suricata:
  pkg.installed:
    - pkgs: 
      - {{ pkg.gen_atom('net-analyzer/suricata') }}
    - require:
      - file: gentoo.portage.packages
