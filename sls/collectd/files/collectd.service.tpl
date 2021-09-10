# Managed by Salt
# -*- mode: jinja2 -*-
[Service]
ExecStart=
ExecStart=/usr/sbin/collectd -C /etc/collectd/collectd.conf
{% if pillar[collectd][service][caps] is defined %}
CapabilityBoundingSet={{ salt.pillar.get('collectd:service:caps', [])|join(" ") }}
{% endif %}
