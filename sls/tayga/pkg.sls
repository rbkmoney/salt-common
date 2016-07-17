tayga_pkg:
  pkg.latest:
    - name: net-proxy/tayga

/etc/init.d/tayga:
  file.managed:
    - source: salt://tayga/tayga.initd
