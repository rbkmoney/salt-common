{% set elastic_version = salt['pillar.get']('elastic:version', '~>=5.1') %}
include:
  - kibana.config

kibana:
  portage_config.flags:
    - name: www-apps/kibana-bin
    - accept_keywords:
      - ~*
  pkg.installed:
    - pkgs:
      - www-apps/kibana-bin: "{{ elastic_version }}"
    - require:
      - portage_config: kibana
  service.running:
    - enable: True
    - watch:
      - pkg: kibana
      - file: /etc/kibana/kibana.yml
      - file: /etc/init.d/kibana

/etc/init.d/kibana:
  file.managed:
    - source: salt://kibana/kibana.initd
    - mode: 755
