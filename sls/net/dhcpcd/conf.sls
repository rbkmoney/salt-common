/etc/dhcpcd.conf:
  file.managed:
    - source:
      - salt://{{ slspath }}/files/by-id/{{ grains.id }}/dhcpcd.conf.tpl
      - salt://{{ slspath }}/files/dhcpcd.conf.tpl
    - mode: 644
    - user: root
    - group: root
