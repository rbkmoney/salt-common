{% set ceph_version = salt['pillar.get']('ceph:version', '=12.2.8-r1') %}
{% set ceph_use = salt['pillar.get']('ceph:use', ('radosgw', 'tcmalloc', 'xfs')) %}
{% set ceph_packaged = salt['pillar.get']('ceph:packaged', True) %}

ceph:
  pkg.installed:
    {% if ceph_packaged %}
    - binhost: force
    {% endif %}
    - pkgs:
      - sys-cluster/ceph: "{{ ceph_version }}[{{ ','.join(ceph_use) }}]"
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

{% for daemon in ('mon', 'mgr', 'osd', 'mds') %}
/var/lib/ceph/{{ daemon }}/:
  file.directory:
    - create: True
    - mode: 755
    - user: ceph
    - group: ceph
    - require:
      - file: /var/lib/ceph/
{% endfor %}

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
