net.ipv4.ip_forward:
  sysctl.present:
    - config: /etc/sysctl.d/ipv4_forwarding.conf
    - value: 0
