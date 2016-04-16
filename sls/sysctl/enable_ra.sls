# -*- mode: yaml -*-
net.ipv6.conf.all.accept_ra:
  sysctl.present:
    - config: /etc/sysctl.d/ipv6_ra.conf
    - value: 1

net.ipv6.conf.default.accept_ra:
  sysctl.present:
    - config: /etc/sysctl.d/ipv6_ra.conf
    - value: 1

