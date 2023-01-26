include:
  - .pkg

/etc/cron.daily/logrotate:
  file.managed:
    - source: salt://logrotate/files/logrotate.cron.daily
    - mode: 755
    - user: root
    - group: root

/etc/logrotate.conf:
  file.managed:
    - source: salt://logrotate/files/logrotate.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/logrotate.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/logrotate.d/wtmp:
  file.absent:
    - require:
      - file: /etc/logrotate.d/

/etc/logrotate.d/btmp:
  file.absent:
    - require:
      - file: /etc/logrotate.d/

{% for config_protect_file in salt['file.find']('/etc/logrotate.d/', name='._cfg*', maxdepth=1) %}
{{ config_protect_file }}:
  file.absent:
    - require:
      - file: /etc/logrotate.d/
{% endfor %}
