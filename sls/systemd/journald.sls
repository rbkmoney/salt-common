include:
  - systemd.common

/etc/systemd/journald.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/journald.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/systemd/

systemd-journald:
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/journald.conf
