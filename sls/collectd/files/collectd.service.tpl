# Managed by Salt
# -*- mode: jinja2 -*-
[Service]
User={{ salt.pillar.get('collectd:service:user', 'collectd') }}
ExecStart=/usr/sbin/collectd -C /etc/collectd/collectd.conf

# A few plugins won't work without some privileges, which you'll have to
# specify using the CapabilityBoundingSet directive below.
#
# Here's a (incomplete) list of the plugins known capability requirements:
#   ceph            CAP_DAC_OVERRIDE
#   dns             CAP_NET_RAW
#   exec            CAP_SETUID CAP_SETGID
#   intel_rdt       CAP_SYS_RAWIO
#   intel_pmu       CAP_SYS_ADMIN
#   iptables        CAP_NET_ADMIN
#   ping            CAP_NET_RAW
#   processes       CAP_NET_ADMIN  (CollectDelayAccounting only)
#   smart           CAP_SYS_RAWIO
#   turbostat       CAP_SYS_RAWIO
#
CapabilityBoundingSet={{ salt.pillar.get('collectd:service:caps', [])|join(" ") }}

# Restart the collectd daemon when it fails.
Restart=on-failure
