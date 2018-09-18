include:
  - java.icedtea3
  - elasticsearch.pkg
  - elasticsearch.config

/etc/elasticsearch/elasticsearch.keystore:
  file.managed:
    - replace: False
    - mode: 660
    - user: elasticsearch
    - group: elasticsearch
    - require:
      - pkg: elasticsearch_pkg

elasticsearch:
  service.running:
    - enable: True
    - watch:
      - pkg: icedtea3
      - pkg: elasticsearch_pkg
      - file: /etc/elasticsearch/elasticsearch.yml
      - file: /etc/elasticsearch/jvm.options
      - file: /etc/security/limits.d/elasticsearch.conf
      - file: /etc/conf.d/elasticsearch
