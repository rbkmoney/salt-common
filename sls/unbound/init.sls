include:
  - unbound.pkg
  - lib.dnssec-root

unbound:
  service.running:
    - enable: True
    - watch:
      - pkg: net-dns/unbound
      - pkg: sys-libs/glibc
      - pkg: net-dns/dnssec-root
      - file: /etc/unbound/unbound.conf
      - file: /etc/unbound/unbound_server.pem
      - file: /etc/unbound/unbound_server.key
      - file: /etc/unbound/unbound_control.key
      - file: /etc/dnssec/

/etc/dnssec/:
  file.directory:
    - user: unbound
    - group: unbound
    - mode: 755
    - require:
      - pkg: net-dns/dnssec-root

/etc/unbound/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: unbound

/etc/unbound/unbound.conf:
  file.managed:
    - source: salt://unbound/unbound.conf.tpl
    - template: jinja
    - mode: 640
    - user: root
    - group: unbound
    - require:
      - file: /etc/unbound/

/etc/unbound/unbound_server.pem:
  file.managed:
    - source: salt://unbound/unbound_server.pem
    - mode: 640
    - user: root
    - group: unbound
    - require:
      - file: /etc/unbound/

/etc/unbound/unbound_server.key:
  file.managed:
    - source: salt://unbound/unbound_server.key
    - mode: 640
    - user: root
    - group: unbound
    - require:
      - file: /etc/unbound/

/etc/unbound/unbound_control.pem:
  file.managed:
    - source: salt://unbound/unbound_control.pem
    - mode: 640
    - user: root
    - group: unbound
    - require:
      - file: /etc/unbound/

/etc/unbound/unbound_control.key:
  file.managed:
    - source: salt://unbound/unbound_control.key
    - mode: 640
    - user: root
    - group: unbound
    - require:
      - file: /etc/unbound/

unbound-control_reconfig:
  cmd.wait:
    - name: /usr/sbin/unbound-control reconfig
    - require:
      - service: unbound
      - file: /etc/unbound/unbound_control.pem
      - file: /etc/unbound/unbound_control.key

unbound-control_reload:
  cmd.wait:
    - name: /usr/sbin/unbound-control reload
    - require:
      - service: unbound
      - file: /etc/unbound/unbound_control.pem
      - file: /etc/unbound/unbound_control.key
