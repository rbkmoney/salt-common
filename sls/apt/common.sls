/etc/apt/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/apt/apt.conf.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apt/

/etc/apt/auth.conf.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apt/

/etc/apt/preferences.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apt/

/etc/apt/sources.list.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apt/

/etc/apt/trusted.gpg.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apt/

/etc/apt/keyrings/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/apt/
