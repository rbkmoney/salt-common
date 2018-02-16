app-admin/restart-services:
  pkg.latest

/etc/restart-services.conf:
  file.managed:
    - source: salt://openrc/files/restart-services.conf.tpl
    - require:
      - pkg: restart-services
