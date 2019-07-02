/etc/sudoers:
  file.managed:
    - source: salt://sudo/sudoers
    - check_cmd: /usr/sbin/visudo -c -f
    - template: jinja
    - mode: 644
    - user: root
    - group: root
