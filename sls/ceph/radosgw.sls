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


{% for client in salt['pillar.get']('ceph:radosgw:clients', []) %}
/etc/init.d/radosgw.{{ client }}:
  file.symlink:
    - target: /etc/init.d/radosgw

radosgw.{{ client }}:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ceph/ceph.conf
      - file: /etc/init.d/radosgw
      - file: /etc/init.d/radosgw.{{ client }}
{% endfor %}
