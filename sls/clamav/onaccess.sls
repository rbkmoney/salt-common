{% import slspath + '/map.jinja' as m %}
include:
  - .pkg
  - .conf
  - .svc-clamd
  - .cron-freshclam
  - .cron-clamdscan

extend:
  {{ m.conf_dir }}/clamd.conf:
    file.managed:
      - source: salt://{{ slspath }}/files/clamd-onacess.conf
  clamd:
    service.running:
      - watch:
        - file: {{ m.conf_dir }}/clamd.conf
        - file: /etc/systemd/system/clamav-daemon.service
        - file: /etc/systemd/system/clamav-onacc.service
        {% if grains['init'] == 'openrc' %}
        - file: /etc/conf.d/clamd
        {% endif %}
        - pkg: app-antivirus/clamav
      - require:
        - file: {{ m.conf_dir }}/freshclam.conf

{{ m.conf_dir }}/clamd-scan.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/clamd-scan.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/systemd/system/clamav-daemon.service:
  file.managed:
    - source: salt://{{ slspath }}/files/clamav-daemon.service
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/systemd/system/clamav-daemon-scan.service:
  file.managed:
    - source: salt://{{ slspath }}/files/clamav-daemon-scan.service
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/systemd/system/clamav-onacc.service:
  file.managed:
    - source: salt://{{ slspath }}/files/clamav-onacc.service
    - template: jinja
    - mode: 644
    - user: root
    - group: root

clamav-onacc.service:
  service.running:
    - enable: True
    - init_delay: 60

/var/log/clamav:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

retrieve_initial_datbases:
  cmd.run:
    - name: freshclam
    - creates: /var/lib/clamav/main.cvd
    - require_in:
      - service: clamd

