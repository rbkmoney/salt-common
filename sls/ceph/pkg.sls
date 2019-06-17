{% import 'pkg/common' as pkg %}
ceph:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('sys-cluster/ceph') }}
  {{ pkg.gen_portage_config('sys-cluster/ceph', watch_in={'pkg': 'sys-cluster/ceph'})|indent(8) }}
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
