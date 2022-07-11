{% set lbs = salt.pillar.get('bird:lbs') %}
{% set ecmp_area_id = lbs.ecmp_area_id %}
{% set ecmp_interface = lbs.get('ecmp_interface', 'eth0') %}
{% set anycast_networks = lbs.get('anycast_networks', {}) %}
log syslog { info, remote, warning, error, auth, fatal, bug, debug };
router id from "{{ ecmp_interface }}";
protocol kernel {
        learn; # Learn all alien routes from the kernel
        persist; # Don't remove routes on bird shutdown
        scan time 20; # Scan kernel routing table every 20 seconds
        ipv4 { import none; export all; };
}
protocol kernel {
        learn; # Learn all alien routes from the kernel
        persist; # Don't remove routes on bird shutdown
        scan time 20; # Scan kernel routing table every 20 seconds
        ipv6 { import none; export all; };
}
protocol bfd {
}
# This pseudo-protocol watches all interface up/down events.
protocol device {
  scan time 10; # Scan interfaces every 10 seconds
}
protocol direct {
    ipv4 {};
    ipv6 {};
    interface "lo";
}

{% for v in ['v4', 'v6'] %}
{% set networks = anycast_networks.get(v, []) %}
{% if networks %}
function allow_anycast_ip{{ v }}()
prefix set anycast{{ v }};
{
  anycast{{ v }} = [ {{ ', '.join(networks) }} ];
  if net ~ anycast{{ v }} then return true;
  return false;
}

filter export_to_ospf{{ v }} {
  if allow_anycast_ip{{ v }}() then accept;
  reject;
}
protocol ospf v3 lbsOSPF{{ v }} {
        ip{{ v }} { export filter export_to_ospf{{ v }}; };
        tick 1;
        ecmp yes;
        stub router yes;
        area {{ ecmp_area_id }} {
             nssa;
             interface "{{ ecmp_interface }}" {
                priority 0;
                bfd yes;
                hello 10;
                retransmit 6;
                transmit delay 5;
                dead count 5;
                wait 50;
                type broadcast;
             };
        };
}
{% endif %}
{% endfor %}
