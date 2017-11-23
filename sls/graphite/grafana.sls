www-apps/grafana-bin:
  portage_config.flags:
    - accept_keywords:
      - ~*
  pkg.latest:
    - require:
      - portage_config: www-apps/grafana-bin

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
