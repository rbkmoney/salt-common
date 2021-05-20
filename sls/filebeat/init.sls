{% set output = salt.pillar.get('filebeat:output') %}
{% set tls = salt.pillar.get('filebeat:tls', {}) %}
include:
  - .pkg
  - .config
  - .service

/etc/conf.d/filebeat:
  file.append:
    - text: "export GODEBUG=x509ignoreCN=0"
    - require: 
      - pkg: app-admin/filebeat

extend:
  filebeat:
    service.running:
      - watch:
        - pkg: app-admin/filebeat
        - file: /etc/filebeat/filebeat.yml
        - file: /etc/filebeat/conf.d/
        - file: /etc/filebeat/filebeat.template.json
        - file: /var/lib/filebeat/module/
        - file: /etc/conf.d/filebeat
        {% for out in output.keys() %}
        {% if out in tls %}
        {% for pemtype in ('cert', 'key', 'ca') %}
        - file: /etc/filebeat/{{ out }}-{{ pemtype }}.pem
        {% endfor %}
        {% endif %}
        {% endfor %}
