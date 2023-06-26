freshclam:
  service.running:
    {% if grains.os_family == 'Debian' %}
    - name: clamav-freshclam
    {% endif %}
    - enable: True
