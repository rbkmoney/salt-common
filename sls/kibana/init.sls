{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - kibana.config

/etc/init.d/kibana:
  file.managed:
    - source: salt://kibana/files/kibana.initd
    - mode: 755

www-apps/kibana-bin:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('www-apps/kibana') }}

kibana:
  service.running:
    - enable: True
    - watch:
      - pkg: www-apps/kibana-bin
      - file: /etc/kibana/kibana.yml
      - file: /etc/init.d/kibana

