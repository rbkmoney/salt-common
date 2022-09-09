# Managed by Salt
{# -*- mode: jinja2 -*- #}
[Service]
ExecStart=
ExecStart=/usr/sbin/collectd -C /etc/collectd/collectd.conf
{% if salt.pillar.get('collectd:service:caps', False) != False %}
CapabilityBoundingSet={{ salt.pillar.get('collectd:service:caps', [])|join(" ") }}
{% endif %}
