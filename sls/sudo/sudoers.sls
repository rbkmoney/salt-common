/etc/sudoers:
  file.managed:
    - source:
      - salt://{{ slspath }}/files/by-id/{{ grains.id }}/sudoers.tpl
      - salt://{{ slspath }}/files/sudoers.tpl
    - template: jinja
    - check_cmd: /usr/sbin/visudo -c -f
    - template: jinja
    - mode: 644
    - user: root
    - group: root
