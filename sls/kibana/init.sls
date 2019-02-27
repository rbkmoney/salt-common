{% set kibana_version = salt['pillar.get']('kibana:version', '~>=6.3') %}
include:
  - nodejs
  - kibana.config

/etc/init.d/kibana:
  file.managed:
    - source: salt://kibana/files/kibana.initd
    - mode: 755

www-apps/kibana-bin:
  pkg.installed:
    - version: "{{ kibana_version }}"
    - require:
      - portage_config: www-apps/kibana-bin
  portage_config.flags:
    - accept_keywords: ["~*"]

kibana:
  service.running:
    - enable: True
    - watch:
      - pkg: www-apps/kibana-bin
      - pkg: net-libs/nodejs
      - file: /etc/kibana/kibana.yml
      - file: /etc/init.d/kibana

