net.ipv4.ip_nonlocal_bind:
  sysctl.present:
    - config: /etc/sysctl.d/nonlocal_bind.conf
    - value: 1

net.ipv6.ip_nonlocal_bind:
  sysctl.present:
    - config: /etc/sysctl.d/nonlocal_bind.conf
    - value: 1
