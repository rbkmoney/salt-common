{% import slspath + '/map.jinja' as m %}
include:
  - .pkg
  - .conf

freshclam:
  service.dead:
    - enable: False
    {% if grains.os_family == 'Debian' %}
    - name: clamav-freshclam
    {% endif %}

cron-freshclam:
  cron.present:
    - identifier: freshclam
    - name: '/usr/local/bin/clam-wrapper.py freshclam >> /var/log/clam.json'
    - minute: '*/30'
    - user: root
    - require:
      - pkg: app-antivirus/clamav
      - file: /usr/local/bin/clam-wrapper.py
