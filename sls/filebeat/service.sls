/etc/filebeat/conf.d:
  file.directory:
    - user:  root
    - group: root
    - mode:  755
    - makedirs: True

filebeat:
  service.running:
    - enable: True
