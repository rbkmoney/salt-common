/etc/auditbeat/auditbeat.yml:
  file.managed:
    - source: salt://{{ tpldir }}/files/auditbeat.yml
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja

/etc/auditbeat/audit.rules.d/rules.conf:
  file.managed:
    - source: salt://{{ tpldir }}/files/rules/pci-dss-audit.conf
    - makedirs: True
    - mode: '0644'
    - user: root
    - group: root
    - template: jinja

/etc/auditbeat/elasticsearch-key.pem:
  file.managed:
    - contents_pillar: auditbeat:tls:key
    - user: root
    - group: root
    - mode: '0600'

/etc/auditbeat/elasticsearch-cert.pem:
  file.managed:
    - contents_pillar: auditbeat:tls:cert
    - user: root
    - group: root
    - mode: '0640'

/etc/auditbeat/elasticsearch-ca.pem:
  file.managed:
    - contents_pillar: auditbeat:tls:ca
    - user: root
    - group: root
    - mode: '0640'
