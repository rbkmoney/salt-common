/etc/sudoers:
  file.managed:
    - source: salt://sudo/sudoers
    - check_cmd: /usr/sbin/visudo -c -f
    - mode: 644
    - user: root
    - group: root
    - template: jinja
