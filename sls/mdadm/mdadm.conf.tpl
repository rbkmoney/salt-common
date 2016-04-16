# mdadm configuration file
# Managed by Salt
{% set default_email = salt['pillar.get']('contacts:default:email', False)  %}
#
#PROGRAM /usr/sbin/handle-mdadm-events
{% if default_email %}MAILADDR {{ default_email }}{% endif %}
