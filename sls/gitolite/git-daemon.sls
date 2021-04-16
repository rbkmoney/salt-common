include:
  - vcs.git

/etc/conf.d/git-daemon:
  file.managed:
    - source: salt://gitolite/files/git-daemon.confd
    - user: root
    - group: root
    - mode: 644

git-daemon:
  service.running:
    - enable: True
    - watch:
      - file: /etc/conf.d/git-daemon
