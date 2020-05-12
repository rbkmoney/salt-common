{% set tls_enabled = salt.pillar.get('elastic:tls:enabled', False) %}
{% set s3_config = salt.pillar.get('elastic:config:repository-s3', {} %}
include:
  - elasticsearch.pkg
  - elasticsearch.config
  {% if tls_enabled %}
  - elasticsearch.opendistro-security
  {% endif %}
  {% if s3_config|length >0 %}
  - elasticsearch.repository-s3
  {% endif %}


create-elasticsearch-keystore:
  cmd.run:
    - env:
      - ES_PATH_CONF: /etc/elasticsearch
    - name: /usr/share/elasticsearch/bin/elasticsearch-keystore create -s
    - creates: /etc/elasticsearch/elasticsearch.keystore
    - require:
      - pkg: app-misc/elasticsearch
      - file: /etc/elasticsearch/ 
    - onchanges:
      - file: wipe-elasticsearch-keystore


wipe-elasticsearch-keystore:
  file.absent:
    - name: /etc/elasticsearch/elasticsearch.keystore
    - onchanges:
      {% if tls_enabled %}
      {% for proto in ('transport', 'http') %}
      {% for pemtype in ('cert', 'key', 'ca') %}
      - file: /etc/elasticsearch/{{ proto }}-{{ pemtype }}.pem
      {% endfor %}
      {% endfor %}
      {% endif %}

/etc/elasticsearch/elasticsearch.keystore:
  file.managed:
    - replace: False
    - mode: 660
    - user: elasticsearch
    - group: elasticsearch
    - watch:
      - cmd: create-elasticsearch-keystore

elasticsearch:
  service.running:
    - enable: True
    - watch:
      - pkg: openjdk-bin11
      - pkg: app-misc/elasticsearch
      - file: /etc/elasticsearch/elasticsearch.yml
      - file: /etc/elasticsearch/jvm.options
      - file: /etc/security/limits.d/elasticsearch.conf
      - file: /etc/conf.d/elasticsearch
      - file: /etc/elasticsearch/elasticsearch.keystore
