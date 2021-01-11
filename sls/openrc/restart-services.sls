{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

app-admin/restart-services:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-admin/restart-services') }}
    - require:
      - file: gentoo.portage.packages

/etc/restart-services.conf:
  file.managed:
    - source: salt://openrc/files/restart-services.conf.tpl
    - template: jinja
    - require:
      - pkg: app-admin/restart-services
