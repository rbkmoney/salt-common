{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - gentoo.repos.rbkmoney

app-misc/opendistro-security-kibana-plugin:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-misc/opendistro-security-kibana-plugin') }}
    - require:
      - file: gentoo.portage.packages
      - git: rbkmoney
