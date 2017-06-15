include:
  - ceph.pkg

/etc/init.d/radosgw:
  file.managed:
    - source: salt://ceph/files/radosgw.initd
    - mode: 755
    - user: root
    - group: root
    - require:
      - pkg: ceph

