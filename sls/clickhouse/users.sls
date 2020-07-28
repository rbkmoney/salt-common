/etc/clickhouse-server/users.xml:
  file.managed:
    - source: salt://clickhouse/files/users.xml.tpl
    - template: jinja
    - mode: 640
    - user: clickhouse
    - group: clickhouse
