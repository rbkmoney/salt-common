include:
  - unbound.pkg
  - lib.dnssec-root

unbound:
  service.running:
    - enable: True
    - watch:
      - pkg: net-dns/unbound
      - pkg: net-dns/dnssec-root
      - file: /etc/unbound/unbound.conf
      - file: /var/lib/unbound/root-anchors.txt
      {% if grains['elibc'] == 'glibc' %}
      - pkg: sys-libs/glibc
      {% endif %}

/etc/unbound/:
  file.directory:
    - create: True
    - mode: '0750'
    - user: root
    - group: unbound
    - require:
      - pkg: net-dns/unbound

/etc/unbound/unbound.conf:
  file.managed:
    - source: salt://unbound/files/unbound.conf.tpl
    - template: jinja
    - mode: '0640'
    - user: root
    - group: unbound
    - require:
      - file: /etc/unbound/

/var/lib/unbound/:
  file.directory:
    - create: True
    - mode: '0755'
    - user: unbound
    - group: unbound
    - require:
      - pkg: net-dns/unbound

/var/lib/unbound/root-anchors.txt:
  file.managed:
    - replace: false
    - source:
      - /etc/dnssec/root-anchors.txt
      - /usr/share/dns/root.ds
    - mode: '644'
    - user: unbound
    - group: unbound
    - require:
      - file: /etc/unbound/
      - pkg: net-dns/dnssec-root

unbound-control-setup:
  cmd.run:
    - name: /usr/sbin/unbound-control-setup
    - require:
      - file: /etc/unbound/
    - unless:
      - test -f /etc/unbound/unbound_control.key
    - watch_in:
      - service: unbound

