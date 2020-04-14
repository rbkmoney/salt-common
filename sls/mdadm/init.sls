include:
  - .pkg

/etc/mdadm.conf:
  file.managed:
    - source: salt://monitoring/files/mdadm.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
          
mdadm:
  service.running:
    - name: mdadm
    - enable: True
    - watch:
      - pkg: sys-fs/mdadm
      - file: /etc/mdadm.conf
