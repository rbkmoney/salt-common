{# -*- mode: jinja2 -*- #}
{% for host, data in salt.pillar.get("gitolite:ssh:hostconfig", {}).items() %}
host {{ host }}
     {% for k,v in data.items() %}
     {{ k }} {{ v }}
     {% endfor %}
{% endfor %}
