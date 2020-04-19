{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - gentoo.repos.rbkmoney

app-misc/opendistro-elasticsearch-plugin:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-misc/opendistro-elasticsearch-plugin') }}
    - require:
      - file: gentoo.portage.packages
      - git: rbkmoney
