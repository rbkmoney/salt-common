/etc/modprobe.d/bonding.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/modprobe-bonding.conf
    - user: root
    - group: root
    - mode: 644

