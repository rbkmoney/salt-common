include:
  - ceph.pkg
  - ceph.conf

/etc/init.d/radosgw:
  file.managed:
    - source: salt://ceph/files/radosgw.initd
    - mode: 755
    - user: root
    - group: root
    - require:
      - pkg: ceph

radosgw:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ceph/ceph.conf
      - file: /etc/init.d/radosgw
