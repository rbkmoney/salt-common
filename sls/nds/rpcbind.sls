{% set rpcbind_version = salt['pillar.get']('nds:rpcbind:version', '>=0.2.4') %}
{% set rpcbind_use = salt['pillar.get']('nds:rpcbind:use', ['-tcpd']) %}
include:
  - lib.libtirpc

net-nds/rpcbind:
  pkg.installed:
    - version: "{{ rpcbind_version }}[{{ ','.join(rpcbind_use) }}]"
    - require:
      - pkg: net-libs/libtirpc
