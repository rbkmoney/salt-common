# Managed by Salt
# TYPE DATABASE USER ADDRESS METHOD
# "local" is for Unix domain socket connections only
{% if pillar_prefix is not defined %}
{% set pillar_prefix = 'postgres' %}
{% endif %}
{% set local_hba_rules = salt['pillar.get'](pillar_prefix + ':pg_hba:local', {'all': [{'user': 'all', 'method': 'trust'}]}) %}
{% for database, rules in local_hba_rules.items() %}
{% for rule in rules %}
local {{ database }} {{ rule['user'] }} {{ rule['method'] }}
{% endfor %}
{% endfor %}

{% set host_hba_rules = salt['pillar.get'](pillar_prefix + ':pg_hba:host', {}) %}
{% for database, rules in host_hba_rules.items() %}
{% for rule in rules %}
host {{ database }} {{ rule['user'] }} {{ rule['network'] }} {{ rule['method'] }}
{% endfor %}
{% endfor %}
