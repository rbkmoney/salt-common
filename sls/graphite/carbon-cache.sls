include:
  - graphite.carbon

/etc/carbon/carbon.conf:
  file.managed:
    - source: salt://graphite/files/carbon.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/carbon/storage-schemas.conf:
  file.managed:
    - source: salt://graphite/files/storage-schemas.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/carbon/storage-aggregation.conf:
  file.managed:
    - source: salt://graphite/files/storage-aggregation.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root

carbon-cache:
  service.running:
    - enable: True
    - watch:
      - pkg: dev-python/carbon
      - file: /etc/carbon/carbon.conf
      - file: /etc/carbon/storage-schemas.conf
      - file: /etc/carbon/storage-aggregation.conf
