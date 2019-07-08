{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

app-admin/consul:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-admin/consul') }}
    - require:
      - file: gentoo.portage.packages
