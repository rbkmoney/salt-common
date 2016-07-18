# Make some notes/includes/grains about a nat64 unbound.
include:
  - tayga.pkg
  - tayga.config

net_nat64:
  service.running:
    - name: 'net.nat64'
    - watch:
      - pkg: tayga_pkg
      - augeas: append-nat64-config
      - file: /lib/netifrc/net/tayga.sh
      - file: /etc/init.d/net.nat64

tayga:
  service.running:
    - enable: True
    - watch:
      - pkg: tayga_pkg
      - user: tayga_user
      - service: net_nat64
      - file: /etc/init.d/tayga
      - file: /etc/tayga.conf
      - file: /var/db/tayga/
