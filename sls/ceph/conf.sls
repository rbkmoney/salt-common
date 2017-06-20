/etc/ceph/ceph.conf:
  file.managed:
    - source: salt://ceph/files/ceph.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: ceph
