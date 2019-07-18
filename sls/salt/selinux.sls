{% if grains.selinux is defined and grains.selinux.enabled == True %}

/etc/bash/bashrc.d/salt-call-selinux.sh:
  file.managed:
    - source: salt://{{ tpldir }}/files/salt-call-selinux.sh.tpl
    - mode: '0600'
    - user: root
    - group: root

{% endif %}

