/etc/salt/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode: 755

/etc/salt/pki/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /etc/salt/
