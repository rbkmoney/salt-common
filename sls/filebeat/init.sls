include:
  - filebeat.pkg
  - filebeat.conf
  - filebeat.service

extend:
  filebeat:
    service.running:
      - watch:
        - pkg: app-admin/filebeat
        - file: /etc/filebeat/filebeat.yml
        - file: /etc/filebeat/conf.d/
        - file: /etc/filebeat/filebeat.template.json
        - file: /var/lib/filebeat/module/
