{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

mail-mta/postfix:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('mail-mta/postfix') }}
    - require:
      - file: gentoo.portage.packages
