{% set output = salt.pillar.get("filebeat:output") %}
{% set tls = salt.pillar.get("filebeat:tls", {}) %}
{% set schedule = salt.pillar.get("filebeat:vault:schedule", {}) %}
include:
  - .config

/etc/filebeat/conf.d/:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/var/lib/filebeat/module/:
  file.recurse:
    - source: salt://filebeat/files/module/
    - file_mode: 640
    - dir_mode: 750
    - user: root
    - group: root

filebeat:
  service.running:
    - enable: True
    - watch:
      - file: /etc/filebeat/filebeat.yml
      - file: /etc/filebeat/conf.d/
      - file: /etc/filebeat/filebeat.template.json
      {% for out in output.keys() %}
      {% if out in tls %}
      {% if tls[out].get("vault", False) %}
      {% for pemtype in ("fullchain", "privkey", "ca_chain") %}
      - file: /etc/pki/filebeat-{{ out }}/{{ pemtype }}.pem
      {% endfor %}
      {% else %}
      {% for pemtype in ("cert", "key", "ca") %}
      - file: /etc/filebeat/{{ out }}-{{ pemtype }}.pem
      {% endfor %}
      {% endif %}
      {% endif %}
      {% endfor %}

{% if schedule.get("enable", False) %}
filebeat-update-certificate:
  schedule.present:
    - function: state.apply
    - job_args: [filebeat.service]
    - hours: {{ schedule.get("hours", 24) }}
    - splay: {{ schedule.get("splay", 300) }}
{% endif %}
