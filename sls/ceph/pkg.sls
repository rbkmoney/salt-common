{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

ceph:
  pkg.installed:
    - binhost: force
    - pkgs:
      - {{ pkg.gen_atom('sys-cluster/ceph') }}
    - require:
      - file: gentoo.portage.packages
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
