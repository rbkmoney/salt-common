include:
  - .pkg
  - .conf

{% set host = grains['host'] %}
{% set use_openrc = grains.get('init') == 'openrc' %}
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

{% if use_openrc %}
/etc/init.d/ceph-mon.{{ host }}:
  file.symlink:
    - target: ceph
{% else %}
/etc/init.d/ceph-mon.{{ host }}:
  file.absent
{% endif %}

{% set ceph_mon_service = 'ceph-mon.' ~ host if use_openrc else 'ceph-mon@' ~ host %}
{{ ceph_mon_service }}:
  service.running:
    - enable: True
    - watch:
      - pkg: ceph
      - file: /etc/ceph/ceph.conf
{% if use_openrc %}
      - file: /etc/init.d/ceph-mon.{{ host }}
{% endif %}
      - file: /var/lib/ceph/mon/ceph-{{ host }}/keyring
{% else %}
{% set ceph_mon_service = 'ceph-mon.' ~ host if use_openrc else 'ceph-mon@' ~ host %}
{{ ceph_mon_service }}:
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

{% if use_openrc %}
/etc/init.d/ceph-mgr.{{ host }}:
  file.symlink:
    - target: ceph
{% else %}
/etc/init.d/ceph-mgr.{{ host }}:
  file.absent
{% endif %}

{% set ceph_mgr_service = 'ceph-mgr.' ~ host if use_openrc else 'ceph-mgr@' ~ host %}
{{ ceph_mgr_service }}:
  service.running:
    - enable: True
    - watch:
      - pkg: ceph
      - file: /etc/ceph/ceph.conf
{% if use_openrc %}
      - file: /etc/init.d/ceph-mgr.{{ host }}
{% endif %}
      - file: /var/lib/ceph/mgr/ceph-{{ host }}/keyring
{% else %}
{% set ceph_mgr_service = 'ceph-mgr.' ~ host if use_openrc else 'ceph-mgr@' ~ host %}
{{ ceph_mgr_service }}:
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

{% if use_openrc %}
/etc/init.d/ceph-osd.{{ osd_id }}:
  file.symlink:
    - target: ceph
{% else %}
/etc/init.d/ceph-osd.{{ osd_id }}:
  file.absent
{% endif %}

{% set ceph_osd_service = 'ceph-osd.' ~ osd_id if use_openrc else 'ceph-osd@' ~ osd_id %}
{{ ceph_osd_service }}:
  service.running:
    - enable: True
    - require:
      - file: /var/lib/ceph/osd/ceph-{{ osd_id }}/whoami
    - watch:
      - pkg: ceph
      - file: /etc/ceph/ceph.conf
{% if use_openrc %}
      - file: /etc/init.d/ceph-osd.{{ osd_id }}
{% endif %}
      - file: /var/lib/ceph/osd/ceph-{{ osd_id }}/keyring
{% endfor %}

{% for client in salt['pillar.get']('ceph:radosgw:clients', []) %}
{% if use_openrc %}
/etc/init.d/radosgw.{{ client }}:
  file.symlink:
    - target: /etc/init.d/radosgw
{% else %}
/etc/init.d/radosgw.{{ client }}:
  file.absent
{% endif %}

{% set radosgw_service = 'radosgw.' ~ client if use_openrc else 'ceph-radosgw@' ~ client %}
{{ radosgw_service }}:
  service.running:
    - enable: True
    - watch:
      - pkg: ceph
      - file: /etc/ceph/ceph.conf
{% if use_openrc %}
      - file: /etc/init.d/radosgw
      - file: /etc/init.d/radosgw.{{ client }}
{% endif %}
{% endfor %}
