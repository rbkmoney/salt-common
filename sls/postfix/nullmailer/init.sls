include:
  - postfix.common

/etc/postfix/main.cf:
  file.managed:
    - source: salt://postfix/nullmailer/main.cf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: postfix

/etc/postfix/master.cf:
  file.managed:
    - source: salt://postfix/nullmailer/master.cf
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: postfix
