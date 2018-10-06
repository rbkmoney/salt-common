/etc/filebeat/conf.d/:
  file.directory:
    - user: root
    - group: root
    - mode: 755

filebeat:
  service.running:
    - enable: True
