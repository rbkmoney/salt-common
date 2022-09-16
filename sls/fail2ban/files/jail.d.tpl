{# -*- mode: jinja2 -*- #}
# Managed by Salt
{% set default = salt.pillar.get("fail2ban:jail:default",
{"findtime": "15m", "bantime": "15m", "chain": "fail2ban"}) %}
{% set jails = salt.pillar.get("fail2ban:jail:jails",
{"sshd": {"enabled": True}}) %}

[DEFAULT]
{% for k,v in default.items() %}
{{ k }} = {{ v }}
{% endfor %}

{% for jail, data in jails.items() %}
[{{ jail }}]
{% for k,v in data.items() %}
{{ k }} = {{ v }}
{% endfor %}
{% endfor %}
