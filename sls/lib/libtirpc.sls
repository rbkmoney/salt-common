{% set libtirpc_version = salt['pillar.get']('nds:libtirpc:version', '>=1.0.2') %}
{% set libtirpc_use = salt['pillar.get']('nds:libtirpc:use', ['kerberos']) %}

net-libs/libtirpc:
  pkg.installed:
    - version: {{ libtirpc_version }}
    - use: {{ libtirpc_use }}
