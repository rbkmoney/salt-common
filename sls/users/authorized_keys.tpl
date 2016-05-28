{% for comment, keys in salt['pillar.get']('users:present:'+user+':keys').items() %}
{% for key in keys %}
{{ key }} {{ comment }}
{% endfor %}
{% endfor %}
