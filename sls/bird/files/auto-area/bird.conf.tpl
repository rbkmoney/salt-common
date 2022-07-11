{% set router_id = grains.server_id %}
{% set conf = salt.pillar.get('bird:conf') %}
{% set area_id = conf.area_id %}
{% set ospf_interface = conf.get('ospf_interface', 'eth0') %}
{% set stub_interface = conf.get('stub_interface', 'docker*') %}
log syslog { info, remote, warning, error, auth, fatal, bug, debug };
router id {{ router_id }};
protocol kernel {
        learn; # Learn all alien routes from the kernel
        persist; # Don't remove routes on bird shutdown
        scan time 20; # Scan kernel routing table every 20 seconds
        ipv6 { import none; export all; };
}
protocol bfd {
  interface "{{ ospf_interface }}" {
    min rx interval 50 ms;
    min tx interval 100 ms;
  };
}
# This pseudo-protocol watches all interface up/down events.
protocol device {
  scan time 10; # Scan interfaces every 10 seconds
}
protocol ospf v3 OSPFv6 {
        ipv6 {};
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
	     interface "{{ stub_interface }}" {
	        stub yes;
             };
        };
}
