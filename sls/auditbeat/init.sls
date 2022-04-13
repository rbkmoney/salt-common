include:
  - .pkg
  - .conf
  - .service

extend:
  auditbeat:
    service.running:
      - watch:
        - pkg: sys-process/auditbeat
        - file: /etc/auditbeat/auditbeat.yml
        - file: /etc/auditbeat/audit.rules.d/rules.conf
        - file: /etc/auditbeat/elasticsearch-key.pem
        - file: /etc/auditbeat/elasticsearch-cert.pem
        - file: /etc/auditbeat/elasticsearch-ca.pem
      - require:
        - file: /etc/auditbeat/auditbeat.yml
        - file: /etc/auditbeat/audit.rules.d/rules.conf
        - file: /etc/auditbeat/elasticsearch-key.pem
        - file: /etc/auditbeat/elasticsearch-cert.pem
        - file: /etc/auditbeat/elasticsearch-ca.pem
  sys-process/auditbeat:
    pkg.installed:
      - require_in:
        - file: /etc/auditbeat/auditbeat.yml
        - file: /etc/auditbeat/audit.rules.d/rules.conf
        - file: /etc/auditbeat/elasticsearch-key.pem
        - file: /etc/auditbeat/elasticsearch-cert.pem
        - file: /etc/auditbeat/elasticsearch-ca.pem

