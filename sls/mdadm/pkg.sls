{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

sys-fs/mdadm:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('sys-fs/mdadm') }}
