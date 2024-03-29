# TODO: Take scan directories from pillar?
{% import slspath + '/map.jinja' as m %}
include:
  - .pkg
  - .conf

cron-clamscan:
  cron.present:
    - identifier: clamscan
    - name: '/usr/local/bin/clam-wrapper.py clamscan --recursive --infected --scan-archive=no /home >> /var/log/clam.json'
    - hour: '*/12'
    - minute: '0'
    - user: root
    - require:
      - pkg: app-antivirus/clamav
      - file: /usr/local/bin/clam-wrapper.py
