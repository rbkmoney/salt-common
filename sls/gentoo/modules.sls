/etc/modules.d/:
  file.directory:
    - create: true
    - user: root
    - group: root
    - mode: 755

/etc/modules.d/placeholder.conf:
  file.managed:
    - create: true
    - replace: false
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /etc/modules.d/
  
/etc/conf.d/modules:
  file.managed:
    - source: salt://gentoo/modules.confd
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /etc/modules.d/
      - file: /etc/modules.d/placeholder.conf
