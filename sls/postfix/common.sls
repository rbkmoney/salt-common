include:
  - .pkg

/etc/mail/aliases:
  file.managed:
    - source: salt://postfix/files/aliases
    - template: jinja
    - mode: 644
    - user: root
    - group: root

newaliases-create:
  cmd.run:
    - name: /usr/bin/newaliases
    - creates: /etc/mail/aliases.db
    - require:
      - file: /etc/mail/aliases

newaliases:
  cmd.wait:
    - name: /usr/bin/newaliases
    - watch:
      - file: /etc/mail/aliases

postfix:
  service.running:
    - enable: True
    - watch:
      - pkg: mail-mta/postfix

postfix-reload:
  service.running:
    - name: postfix
    - reload: True
    - require:
      - pkg: mail-mta/postfix
    - watch:
      - cmd: newaliases-create
      - cmd: newaliases
