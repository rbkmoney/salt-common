{% set krb5_version = salt['pillar.get']('kerberos:krb5:version', '>=1.15.2') %}
{% set krb5_use = salt['pillar.get']('kerberos:krb5:use', []) %}

app-crypt/mit-krb5:
  pkg.installed:
    - version: "{{ krb5_version }}"
    - use: {{ krb5_use }}
