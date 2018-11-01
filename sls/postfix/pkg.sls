{% set postfix_version = salt['pillar.get']('postfix:version', '>=3.3.1-r1') %}
{% set postfix_use = salt['pillar.get']('postfix:use', ('hardened', 'berkdb', '-dovecot-sasl', '-memcached', '-mysql') %}
#['berkdb', 'dovecot-sasl', 'hardened', 'memcached', 'mysql', 'pam', 'ssl']
{% set postfix_packaged = salt['pillar.get']('postfix:packaged', False) %}

mail-mta/postfix:
  pkg.installed:
    - version: "{{ postfix_version }}[{{ ','.join(postfix_use) }}]"
    {% if postfix_packaged %}
    - binhost: force
    {% endif %}
