{% if grains['init'] == 'openrc' %}
include:
  - openrc.pkg
  - openrc.conf
  - openrc.restart-services
{% endif %}
