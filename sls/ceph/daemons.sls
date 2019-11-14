include:
  - .pkg
  - .conf

{% set host = grains['host'] %}
{% set enable_ceph_mon = salt['pillar.get']('ceph:mon:enable', False) %}
{% set enable_ceph_mgr = salt['pillar.get']('ceph:mgr:enable', False) %}
{% set host_osd_list = salt['pillar.get']('ceph:osd:list', []) %}

{% if enable_ceph_mon %}
/var/lib/ceph/mon/ceph-{{ host }}/:
  file.directory:
    - mode: 755
    - user: ceph
    - group: ceph
    - require:
      - file: /var/lib/ceph/mon/

/var/lib/ceph/mon/ceph-{{ host }}/keyring:
  file.managed:
    - create: False
    - replace: False
    - mode: 600
    - user: ceph
    - group: ceph
    - require:
      - file: /var/lib/ceph/mon/ceph-{{ host }}/

/etc/init.d/ceph-mon.{{ host }}:
  file.symlink:
    - target: ceph

ceph-mon.{{ host }}:
  service.running:
    - enable: True
    - watch:
      - pkg: ceph
      - file: /etc/ceph/ceph.conf
      - file: /etc/init.d/ceph-mon.{{ host }}
      - file: /var/lib/ceph/mon/ceph-{{ host }}/keyring
{% else %}
ceph-mon.{{ host }}:
  service.dead:
    - enable: False
{% endif %}

{% if enable_ceph_mgr %}
/var/lib/ceph/mgr/ceph-{{ host }}/:
  file.directory:
    - mode: 755
    - user: ceph
    - group: ceph
    - require:
      - file: /var/lib/ceph/mgr/

/var/lib/ceph/mgr/ceph-{{ host }}/keyring:
  file.managed:
    - create: False
    - replace: False
    - mode: 600
    - user: ceph
    - group: ceph
    - require:
      - file: /var/lib/ceph/mgr/ceph-{{ host }}/

/etc/init.d/ceph-mgr.{{ host }}:
  file.symlink:
    - target: ceph

ceph-mgr.{{ host }}:
  service.running:
    - enable: True
    - watch:
      - pkg: ceph
      - file: /etc/ceph/ceph.conf
      - file: /etc/init.d/ceph-mgr.{{ host }}
      - file: /var/lib/ceph/mgr/ceph-{{ host }}/keyring
{% else %}
ceph-mgr.{{ host }}:
  service.dead:
    - enable: False
{% endif %}

{% for osd_id in host_osd_list %}
/var/lib/ceph/osd/ceph-{{ osd_id }}/:
  file.directory:
    - mode: 755
    - user: ceph
    - group: ceph
    - require:
      - file: /var/lib/ceph/osd/

/var/lib/ceph/osd/ceph-{{ osd_id }}/keyring:
  file.managed:
    - create: False
    - replace: False
    - mode: 600
    - user: ceph
    - group: ceph
    - require:
      - file: /var/lib/ceph/osd/ceph-{{ osd_id }}/

/var/lib/ceph/osd/ceph-{{ osd_id }}/whoami:
  file.exists

/etc/init.d/ceph-osd.{{ osd_id }}:
  file.symlink:
    - target: ceph

ceph-osd.{{ osd_id }}:
  service.running:
    - enable: True
    - require:
      - file: /var/lib/ceph/osd/ceph-{{ osd_id }}/whoami
    - watch:
      - pkg: ceph
      - file: /etc/ceph/ceph.conf
      - file: /etc/init.d/ceph-osd.{{ osd_id }}
      - file: /var/lib/ceph/osd/ceph-{{ osd_id }}/keyring
{% endfor %}

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
