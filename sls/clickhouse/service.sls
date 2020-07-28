/etc/clickhouse-server/:
  file.directory:
   - create: True
   - dir_mode: 755
   - user: clickhouse
   - group: clickhouse

/etc/clickhouse-server/config.xml:
  file.managed:
    - source: salt://clickhouse/files/config.xml.tpl
    - template: jinja
    - mode: 640
    - user: clickhouse
    - group: clickhouse
    - require:
      - file: /etc/clickhouse-server/

/var/log/clickhouse-server/:
  file.directory:
    - create: True
    - dir_mode: 755
    - file_mode: 640
    - user: clickhouse
    - group: clickhouse
    - recurse:
      - user
      - group
      - mode

clickhouse-server:
  service.running:
    - enable: True
    - watch:
      - file: /etc/clickhouse-server/config.xml
      - file: /var/log/clickhouse-server/

