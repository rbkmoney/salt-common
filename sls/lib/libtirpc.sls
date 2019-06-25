# TODO: make oneshot
{% set libtirpc_version = salt['pillar.get']('nds:libtirpc:version', '>=1.0.2') %}
{% set libtirpc_use = salt['pillar.get']('nds:libtirpc:use', ['kerberos']) %}
{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}

net-libs/libtirpc:
  pkg.installed:
    - version: "{{ libtirpc_version }}[{{ ','.join(libtirpc_use) }}]"
    {% if consul_packaged %}
    - binhost: force
    {% endif %}
