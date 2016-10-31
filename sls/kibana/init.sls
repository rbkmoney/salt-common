include:
  - kibana.config

kibana:
  portage_config.flags:
    - name: www-apps/kibana-bin
    - accept_keywords:
      - ~*
  pkg.installed:
    - pkgs:
      - www-apps/kibana-bin: "~<5.0.0"
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

'paxctl-ng-kibana':
  cmd.run:
    - name: 'paxctl -cm /opt/kibana/node/bin/node'
    - onchange:
      - pkg: kibana

'paxctl-ng-kibana-onfail':
  cmd.run:
    - name: 'service kibana stop; paxctl -cm /opt/kibana/node/bin/node'
    - onfail:
      - cmd: paxctl-ng-kibana
