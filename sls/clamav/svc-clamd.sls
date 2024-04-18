{% import slspath + '/map.jinja' as m %}
clamd:
  service.running:
    {% if grains.os_family == 'Debian' %}
    - name: clamav-daemon
    {% endif %}
    - enable: True
    - watch:
      - file: {{ m.conf_dir }}/clamd.conf
