{% import 'pkg/common' as pkg %}
include:
  - gentoo.repos.{{ pillar.get('overlay') }}
  - gentoo.portage.packages

app-admin/uwsgitop:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('app-admin/uwsgitop') }}
    - require:
      - file: gentoo.portage.packages
