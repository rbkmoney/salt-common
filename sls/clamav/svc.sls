clamd:
  service.running:
    {% if grains.os_family == 'Debian' %}
    - name: clamav-daemon
    {% endif %}
    - enable: True
