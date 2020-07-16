{% if salt['grains.get']('init') != 'systemd' %}
include:
  - openrc.pkg
  - openrc.conf
  - openrc.restart-services
{% endif %}
