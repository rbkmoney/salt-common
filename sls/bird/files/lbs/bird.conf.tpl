{% set lbs = salt.pillar.get('bird:lbs') %}
{% set ecmp_areas = lbs.ecmp_areas %}
{% set router_id = lbs.get('router-id', 'from eth0') %}
{% set anycast_networks = lbs.get('anycast_networks', {}) %}
log syslog { info, remote, warning, error, auth, fatal, bug, debug };
router id {{ router_id }};
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
	{% for area, data in ecmp_areas.items() %}
        area {{ area }} {
	     {% set area_type = data.get('type', None) %}
	     {% if area_type == 'nssa' %}
	     nssa;
	     {% endif %}
	     {% for iface, ifdata in data['interfaces'].items() %}
             interface "{{ iface }}" {
                type {{ ifdata.get('type', 'broadcast') }};
                priority {{ ifdata.get('priority', 0) }};
                bfd {{ ifdata.get('bfd', 'yes') }};;
                hello {{ ifdata.get('hello', 10) }};
                retransmit {{ ifdata.get('retransmit', '6') }};
                transmit {{ ifdata.get('transmit', 'delay 5') }};
                dead {{ ifdata.get('dead', 'count 4') }};
                wait {{ ifdata.get('wait', '50') }};
             };
	     {% endfor %}
        };
	{% endfor %}
}
{% endif %}
{% endfor %}
