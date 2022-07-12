include:
  - .pkg
  - .cron-clamscan
  - .cron-freshclam
  - .clam-wrapper

/etc/freshclam.conf:
  file.managed:
    - source: salt://clamav/files/freshclam.conf
    - mode: 644
    - user: root
    - group: root

clamd_dead_svc:
  service.dead:
    {% if grains.os_family == 'Debian' %}
    - name: clamav-daemon
    {% else %}
    - name: clamd
    {% endif %}
    - enable: False
