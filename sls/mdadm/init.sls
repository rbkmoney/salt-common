mdadm:
  pkg.installed:
    - pkgs:
      - sys-fs/mdadm:

/etc/mdadm.conf:
  file.managed:
    - source: salt://mdadm/mdadm.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
          
mdadm_monitor:
  service.running:
    - name: mdadm
    - enable: True
    - watch:
      - pkg: mdadm
      - file: /etc/mdadm.conf
