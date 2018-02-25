include:
  - java.icedtea3
  - elasticsearch.pkg
  - elasticsearch.config

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
