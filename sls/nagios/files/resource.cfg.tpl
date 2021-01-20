# Managed by Salt
{% set user_vals = salt.pillar.get('nagios:conf:resource', ['/usr/lib/nagios/plugins']) %}
{% for val in user_vals %}
$USER{{ loop.index }}$={{ val }}
{% endfor %}
