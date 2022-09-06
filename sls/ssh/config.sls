/etc/ssh/sshd_config.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://{{ slspath }}/files/sshd_config.tpl
    - template: jinja
    - mode: 600
    - user: root
    - group: root
    - require:
      - file: /etc/ssh/sshd_config.d/
