{% set suricata = salt['pillar.get']('suricata', {}) -%}
{% set instances = suricata.get('instances', {}) -%}

include:
  - suricata.pkg
  - augeas.lenses

/etc/conf.d/suricata:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - contents: |
        # Managed by Salt
        # Config file for /etc/init.d/suricata
        {% for name,data in instances.items() %}
        {% for key in ('OPTS','LOG_FILE','USER','GROUP') %}
        {% if 'SURICATA_' + key in data %}
        SURICATA_{{ key }}_{{ name }} = "{{ data['SURICATA_' + key] }}"
        {% endif %}{% endfor %}{% endfor %}

{% for name,data in instances.items() %}
/etc/suricata/suricata-{{ name }}.yaml:
  file.serialize:
    {% if data.get('conf', False) %}
    - dataset_pillar: 'suricata:' + {{ instance }} + ':conf'
    {% else %}
    - dataset_pillar: 'suricata:conf'
    {% endif %}
    - formatter: yaml
    - mode: 644
    - user: root
    - group: root

/etc/init.d/suricata.{{ name }}:
  file.symlink:
    - target: /etc/init.d/suricata

suricata.{{ name }}:
  service.running:
    - enabled: True
    - watch:
      - pkg: net-analyzer/suricata
      - file: /etc/conf.d/suricata
      - file: /etc/init.d/suricata.{{ name }}
      - file: /etc/suricata/suricata-{{ name }}.yaml
{% endfor %}
