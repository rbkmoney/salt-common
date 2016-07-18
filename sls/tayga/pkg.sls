tayga_pkg:
  pkg.latest:
    - name: net-proxy/tayga

tayga_user:
  user.present:
    - name: tayga
    - system: True
    - createhome: False

/etc/init.d/tayga:
  file.managed:
    - source: salt://tayga/tayga.initd
    - mode: 755
    - user: root
    - group: root

/lib/netifrc/net/tayga.sh:
  file.managed:
    - source: salt://tayga/tayga.sh
    - mode: 644
    - user: root
    - group: root

/var/db/tayga/:
  file.directory:
    - create: True
    - mode: 750
    - user: tayga
    - group: tayga
