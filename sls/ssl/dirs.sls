
/etc/ssl/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/ssl/certs/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/pki/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
