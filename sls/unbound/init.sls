include:
  - unbound.pkg
  - lib.dnssec-root

unbound:
  service.running:
    - enable: True
    - watch:
      - pkg: net-dns/unbound
      - pkg: net-dns/dnssec-root
      - pkg: sys-libs/glibc
      - file: /etc/unbound/unbound.conf
      - file: /etc/dnssec/

/etc/dnssec/:
  file.directory:
    - user: unbound
    - group: unbound
    - mode: '0755'
    - require:
      - pkg: net-dns/dnssec-root

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
    - source: salt://unbound/unbound.conf.tpl
    - template: jinja
    - mode: '0640'
    - user: root
    - group: unbound
    - require:
      - file: /etc/unbound/

unbound-control-setup:
  cmd.run:
    - name: /usr/sbin/unbound-control-setup
    - require:
      - file: /etc/unbound/
    - unless:
      - test -f /etc/unbound/unbound_control.key
    - watch_in:
      - cmd: unbound-control_reload
    - require_in:
      - cmd: unbound-control_reload

unbound-control_reload:
  cmd.wait:
    - name: /usr/sbin/unbound-control reload
    - require:
      - service: unbound
