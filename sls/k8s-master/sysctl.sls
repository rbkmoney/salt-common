{% set sysctl = {
    "net.bridge.bridge-nf-call-ip6tables": "1",
    "net.bridge.bridge-nf-call-iptables": "1",
    "net.ipv4.ip_forward": "1",
    "net.ipv6.conf.default.forwarding": "1",
    "net.ipv6.conf.all.forwarding": "1",
    "net.ipv4.conf.all.rp_filter": "0",
    "net.ipv4.conf.default.rp_filter": "0",
  }
%}

echo 'net.ipv4.conf.*.rp_filter = 0' > /etc/sysctl.d/99-k8s.conf:
  cmd.run

clear_net.ipv4.ip_forward:
  cmd.run:
    - name: sed -i '/^net.ipv4.ip_forward/Id' /etc/sysctl.conf
    - onlyif:
      - grep ^net.ipv4.ip_forward /etc/sysctl.conf

{% for key, value in sysctl.items() %}
{{ key }}:
  sysctl.present:
    - value: {{ value }}
    - config: /etc/sysctl.d/99-k8s.conf
    - require:
      - kmod: k8s_kmod
      - cmd: echo 'net.ipv4.conf.*.rp_filter = 0' > /etc/sysctl.d/99-k8s.conf
{% endfor %}

