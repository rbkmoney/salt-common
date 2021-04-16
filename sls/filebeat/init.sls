{% set output = salt.pillar.get('filebeat:output') %}
{% set tls = salt.pillar.get('filebeat:tls', {}) %}
include:
  - .pkg
  - .config
  - .service

/etc/env.d/50filebeat
  file.managed:
    - contents: |
        GODEBUG="x509ignoreCN=0"
    - mode: 755
    - user: root
    - group: root

env-update:
  cmd.run:
    - name: env-update
    - onchanges:
      - file: /etc/env.d/50filebeat
    - require:
      - file: /etc/env.d/50filebeat

extend:
  filebeat:
    service.running:
      - watch:
        - pkg: app-admin/filebeat
        - file: /etc/filebeat/filebeat.yml
        - file: /etc/filebeat/conf.d/
        - file: /etc/filebeat/filebeat.template.json
        - file: /var/lib/filebeat/module/
        - cmd: env-update
        {% for out in output.keys() %}
        {% if out in tls %}
        {% for pemtype in ('cert', 'key', 'ca') %}
        - file: /etc/filebeat/{{ out }}-{{ pemtype }}.pem
        {% endfor %}
        {% endif %}
        {% endfor %}
