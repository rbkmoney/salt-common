/var/lib/gitolite/:
  file.directory:
    - user: git
    - group: git
    - mode: 750

/var/lib/gitolite/.ssh/:
  file.directory:
    - user: git
    - group: git
    - mode: 750
    - require:
      - file: /var/lib/gitolite/

/var/lib/gitolite/.gitolite.rc:
  file.managed:
    - source: salt://gitolite/files/gitolite.rc
    - user: git
    - group: git
    - mode: 640
    - require:
      - file: /var/lib/gitolite/

/var/lib/gitolite/.ssh/config:
  file.managed:
    - source: salt://gitolite/files/ssh_config.tpl
    - template: jinja
    - user: git
    - group: git
    - file_mode: 640
    - require:
      - file: /var/lib/gitolite/.ssh/

/var/lib/gitolite/start.pub:
  file.managed:
    - source: salt://gitolite/files/start.pub
    - mode: 640
    - user: git
    - group: git
    - require:
      - file: /var/lib/gitolite/
