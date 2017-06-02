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

'paxctl-ng-kibana':
  cmd.run:
    - name: 'setfattr -n user.pax.flags -v "em" /opt/kibana/node/bin/node'
    - unless: 'test $(getfattr -n user.pax.flags /opt/kibana/node/bin/node --only-values) == "em"'
    - onchange:
      - pkg: kibana
    - watch_in:
      - service: kibana

'paxctl-ng-kibana-onfail':
  cmd.run:
    - name: 'service kibana stop; sleep 10; paxctl-ng -em /opt/kibana/node/bin/node'
    - onfail:
      - cmd: paxctl-ng-kibana
    - watch_in:
      - service: kibana
