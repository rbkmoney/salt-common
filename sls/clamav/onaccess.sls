{% import slspath + '/map.jinja' as m %}
include:
  - .pkg
  - .conf
  - .svc-clamd

extend:
  {{ m.conf_dir }}/clamav.conf:
    file.managed:
      - source: salt://{{ slspath }}/files/clamd-onacess.conf
  clamd:
    service.running:
      - watch:
        - file: {{ m.conf_dir }}/clamav.conf
        {% if grains['init'] == 'openrc' %}
        - file: /etc/conf.d/clamd
        {% endif %}
        - pkg: app-antivirus/clamav
























