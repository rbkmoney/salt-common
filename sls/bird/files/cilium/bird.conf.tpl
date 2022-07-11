{% set router_id = grains.server_id %}
{% set conf = salt.pillar.get('bird:conf') %}
{% set area_id = conf.area_id %}
{% set ospf_interface = conf.get('ospf_interface', 'eth0') %}
{% if salt.file.file_exists('/etc/kubernetes/pod_cidr') %}
{% set cidr_list = salt.file.read('/etc/kubernetes/pod_cidr').split('\n') %}
{% else %}
{% set cidr_list = [] %}
{% endif %}
log syslog { info, remote, warning, error, auth, fatal, bug, debug };
router id {{ router_id }};
# This pseudo-protocol watches all interface up/down events.
protocol device {
  scan time 10; # Scan interfaces every 10 seconds
}
protocol kernel {
  learn no; # Learn all alien routes from the kernel
  persist yes; # Don't remove routes on bird shutdown
  scan time 20; # Scan kernel routing table every 20 seconds
  ipv6 {
    import none;
    export filter {
      if proto = "OSPFv6export" then reject;
      accept;
    };};
}
protocol direct direct1 {
  ipv4 {};
  ipv6 {};
  interface "lo";
}
protocol bfd {
  interface "{{ ospf_interface }}" {
    min rx interval 50 ms;
    min tx interval 100 ms;
  };
}
protocol static OSPFv6export {
  ipv6 {};
  check link;
  {% for cidr in cidr_list %}
  {% if cidr %}route {{ cidr }} via "cilium_host";{% endif %}
  {% endfor %}
}
protocol ospf v3 OSPFv6 {
  ipv6 {
    import all;
    export filter {
      if proto = "OSPFv6export" then accept;
      if proto = "direct1" then accept;
      reject;
    };};
  tick 1;
  ecmp yes;
  stub router yes;
  area {{ area_id }} {
    nssa;
    interface "{{ ospf_interface }}" {
      bfd yes;
      hello 10;
      retransmit 6;
      transmit delay 5;
      dead count 5;
      wait 50;
      type broadcast;
      priority 1;
    };
  };
}
