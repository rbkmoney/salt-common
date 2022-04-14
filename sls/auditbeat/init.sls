include:
  - .pkg
  - .config
  - .service
{% set ouput = pillar('auditbeat:output') %}
{% set tls = salt.pillar.get('auditbeat:tls', {}) %}

extend:
  auditbeat:
    service.running:
      - watch:
        - pkg: sys-process/auditbeat
        - file: /etc/auditbeat/auditbeat.yml
        - file: /etc/auditbeat/audit.rules.d/
        {% for out in output %}
        {% if out in tls.keys() %}
        {% for pemtype in ['cert', 'key', 'ca'] %}
        - file: /etc/auditbeat/{{ out }}-{{ pemtype }}.pem
        {% endfor %}
        {% endif %}
        {% endfor %}
