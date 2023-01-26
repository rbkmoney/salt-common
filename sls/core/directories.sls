/var/:
  file.directory:
    - mode: 755
    - user: root
    - group: root

/var/log/:
  file.directory:
    - mode: 755
    - user: root
    - group: root

/var/tmp/:
  file.directory:
    - mode: 1777
    - user: root
    - group: root

/tmp/:
  file.directory:
    - mode: 1777
    - user: root
    - group: root
