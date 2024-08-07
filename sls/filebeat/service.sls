{% set output = salt.pillar.get('filebeat:output') %}
{% set tls = salt.pillar.get('filebeat:tls', {}) %}
include:
  - .config

/etc/filebeat/conf.d/:
  file.directory:
    - user: root
    - group: root
    - mode: 755

filebeat:
  service.running:
    - enable: True
    - watch:
      - file: /etc/filebeat/filebeat.yml
      - file: /etc/filebeat/conf.d/
      - file: /etc/filebeat/filebeat.template.json
      - file: /var/lib/filebeat/module/
      {% for out in output.keys() %}
      {% if out in tls %}
      {% if tls[out].get("vault", False) %}
      {% for pemtype in ('fullchain', 'privkey', 'ca_chain') %}
      - file: /etc/pki/filebeat-{{ out }}/{{ pemtype }}.pem
      {% endfor %}
      {% else %}
      {% for pemtype in ('cert', 'key', 'ca') %}
      - file: /etc/filebeat/{{ out }}-{{ pemtype }}.pem
      {% endfor %}
      {% endif %}
      {% endif %}
      {% endfor %}
