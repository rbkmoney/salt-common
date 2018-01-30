net.ipv6.conf.all.forwarding:
  sysctl.present:
    - config: /etc/sysctl.d/ipv6_forwarding.conf
    - value: 1

{% set net_ipv6_conf = salt['pillar.get']('sysctl:net:ipv6:conf', {'default': {}}) %}
{% for name, conf in net_ipv6_conf.items() %}
{% if 'forwarding' in conf %}
# This clears a router bit in neighbor advertisement flags
net.ipv6.conf.{{ name }}.forwarding:
  sysctl.present:
    - config: /etc/sysctl.d/ipv6_forwarding.conf
    - value: {{ conf['forwarding'] }}
{% endif %}
{% endfor %}
