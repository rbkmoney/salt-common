{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

www-apps/grafana-bin:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('www-apps/grafana-bin') }}
    - require:
      - file: gentoo.portage.packages

/etc/grafana/grafana.ini:
  file.managed:
    - source: salt://graphite/files/grafana.ini.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root

grafana:
  service.running:
    - enable: True
    - watch:
      - pkg: www-apps/grafana-bin
      - file: /etc/grafana/grafana.ini
