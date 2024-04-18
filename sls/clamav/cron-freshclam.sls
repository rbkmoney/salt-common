{% import slspath + '/map.jinja' as m %}
include:
  - .pkg
  - .conf

cron-freshclam:
  cron.present:
    - identifier: freshclam
    - name: '/usr/local/bin/clam-wrapper.py freshclam >> /var/log/clam.json'
    - minute: '0'
    - hour: '*/6'
    - user: root
    - require:
      - pkg: app-antivirus/clamav
      - file: /usr/local/bin/clam-wrapper.py
