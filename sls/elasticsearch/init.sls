include:
  - java.icedtea3
  - elasticsearch.pkg
  - elasticsearch.config

create-elasticsearch-keystore:
  cmd.run:
    - name: /usr/share/elasticsearch/bin/elasticsearch-keystore
    - creates: /etc/elasticsearch/elasticsearch.keystore
    - require:
      - pkg: app-misc/elasticsearch
      - file: /etc/elasticsearch/

/etc/elasticsearch/elasticsearch.keystore:
  file.managed:
    - replace: False
    - mode: 660
    - user: elasticsearch
    - group: elasticsearch
    - require:
      - cmd: create-elasticsearch-keystore

elasticsearch:
  service.running:
    - enable: True
    - watch:
      - pkg: icedtea3
      - pkg: app-misc/elasticsearch
      - file: /etc/elasticsearch/elasticsearch.yml
      - file: /etc/elasticsearch/jvm.options
      - file: /etc/security/limits.d/elasticsearch.conf
      - file: /etc/conf.d/elasticsearch
      - cmd: create-elasticsearch-keystore
      - file: /etc/elasticsearch/elasticsearch.keystore
