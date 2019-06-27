{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

app-admin/uwsgitop:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('app-admin/uwsgitop') }}
    - require:
      - file: gentoo.portage.packages
