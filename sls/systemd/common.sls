/etc/systemd/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/systemd/system/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/systemd/

/etc/systemd/system-preset/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/systemd/

/etc/systemd/user/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/systemd/
