{% set ceph_version = salt['pillar.get']('ceph:version', '~=12.2.5') %}
{% set ceph_use = salt['pillar.get']('ceph:use', ('radosgw', 'tcmalloc', 'xfs')) %}
ceph:
  pkg.installed:
    - pkgs:
      - sys-cluster/ceph: "{{ ceph_version }}[{{ ','.join(ceph_use) }}]"
      - dev-libs/boost: ">=1.65.0[python,context]"
  user.present:
    - system: True
    - home: /var/lib/ceph
    - shell: /sbin/nologin
    - gid_from_name: True

/etc/ceph/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: ceph
    - require:
      - user: ceph

/var/lib/ceph/:
  file.directory:
    - create: True
    - mode: 755
    - user: ceph
    - group: ceph
    - require:
      - user: ceph

/var/lib/ceph/mon/:
  file.directory:
    - create: True
    - mode: 755
    - user: ceph
    - group: ceph
    - require:
      - file: /var/lib/ceph/

/var/lib/ceph/osd/:
  file.directory:
    - create: True
    - mode: 755
    - user: ceph
    - group: ceph
    - require:
      - file: /var/lib/ceph/

/var/lib/ceph/mds/:
  file.directory:
    - create: True
    - mode: 755
    - user: ceph
    - group: ceph
    - require:
      - file: /var/lib/ceph/

/var/log/ceph/:
  file.directory:
    - create: True
    - mode: 755
    - user: ceph
    - group: ceph
    - require:
      - user: ceph

/var/log/ceph/stat/:
  file.directory:
    - create: True
    - mode: 755
    - user: ceph
    - group: ceph
    - require:
      - file: /var/log/ceph/
