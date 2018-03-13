{% set utils_version = salt['pillar.get']('nfs:utils:version', '>=2.3.1') %}
{% set utils_use = salt['pillar.get']('nfs:utils:use', ['caps','kerberos','nfsv4','nfsv41','-tcpd']) %}
{% set utils_use_str = '[' + ']' %}
include:
  - nds.rpcbind
  {% if 'kerberos' in utils_use %}
  - kerberos.pkg
  {% endif %}

net-fs/nfs-utils:
  pkg.installed:
    - version: "{{ utils_version }}"
    - uses: {{ utils_use }}
    - require:
      - pkg: net-libs/libtirpc
      - pkg: net-nds/rpcbind
      {% if 'kerberos' in utils_use %}
      - pkg: app-crypt/mit-krb5
      {% endif %}
