{% set kibana_version = salt['pillar.get']('kibana:version', '~>=6.1') %}
include:
  - nodejs
  - kibana.config

/etc/init.d/kibana:
  file.managed:
    - source: salt://kibana/kibana.initd
    - mode: 755

kibana:
  portage_config.flags:
    - name: www-apps/kibana-bin
    - accept_keywords:
      - ~*
  pkg.installed:
    - pkgs:
      - www-apps/kibana-bin: "{{ kibana_version }}"
    - require:
      - portage_config: kibana
  service.running:
    - enable: True
    - watch:
      - pkg: kibana
      - pkg: net-libs/nodejs
      - file: /etc/kibana/kibana.yml
      - file: /etc/init.d/kibana

