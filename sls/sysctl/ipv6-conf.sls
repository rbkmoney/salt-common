{% set net_ipv6_conf = salt['pillar.get']('sysctl:net:ipv6:conf', {'default': {}}) %}
{% for name, conf in net_ipv6_conf.items() %}
{% for key, value in conf.items() %}
net.ipv6.conf.{{ name }}.{{ key }}:
  sysctl.present:
    - config: /etc/sysctl.d/ipv6_forwarding.conf
    - value: {{ value }}
{% endfor %}
{% endfor %}
