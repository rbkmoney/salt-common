/etc/ssh/sshd_config.d:
  file.directory

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://{{ slspath }}/files/sshd_config.conf
    - mode: 600
    - user: root
    - group: root
    - require:
      - file: /etc/ssh/sshd_config.d
