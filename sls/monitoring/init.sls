include:
  - .monitoring-plugins
  {% if grains.os_family == 'Gentoo' %}- .check-glsa{% endif %}
  {% if 'bird' in pillar %}- .bird{% endif %}
  {% if 'riak' in pillar %}- .riak{% endif %}
