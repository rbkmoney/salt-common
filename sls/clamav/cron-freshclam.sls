include:
  - .pkg

cron-freshclam:
  cron.present:
    - identifier: freshclam
    - name: '/usr/local/bin/clam-wrapper.py freshclam >> /var/log/clam.json'
    - minute: '*/30'
    - user: root
    - require:
      - pkg: app-antivirus/clamav
      - file: /usr/local/bin/clam-wrapper.py
