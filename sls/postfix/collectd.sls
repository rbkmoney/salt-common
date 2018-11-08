include:
  - collectd

/etc/collectd/conf.d/postfix.conf:
  file.managed:
    - source: salt://postfix/files/collectd-postfix.conf
    - mode: 644
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd/conf.d/
    - watch_in:
      - service: collectd
