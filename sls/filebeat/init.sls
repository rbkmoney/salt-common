include:
  - filebeat.pkg
  - filebeat.conf
  - filebeat.service

extend:
  filebeat:
    service.running:
      - watch:
        - pkg: filebeat_pkg
        - file: /etc/filebeat/filebeat.yml
        - file: /etc/filebeat/conf.d
        - file: /etc/filebeat/filebeat.template.json
