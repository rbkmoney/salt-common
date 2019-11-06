/etc/ceph/ceph.conf:
  file.managed:
    - source: salt://ceph/files/ceph.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: ceph

/etc/init.d/ceph:
  file.managed:
    - source: salt://ceph/files/ceph.initd
    - template: jinja
    - mode: 755
    - user: root
    - group: root
