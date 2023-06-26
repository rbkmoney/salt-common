include:
  - .pkg
  - .conf
  - .cron-clamscan
  - .cron-freshclam

clamd_dead_svc:
  service.dead:
    {% if grains.os_family == 'Debian' %}
    - name: clamav-daemon
    {% else %}
    - name: clamd
    {% endif %}
    - enable: False
