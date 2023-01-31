include:
  - .minion-config
  - .selinux
  - .pkg

salt-minion:
  service.running:
    - enable: True
    - order: last
    - watch:
      - file: /etc/salt/minion
      - pkg: app-admin/salt

{% if not salt.pillar.get('salt:master', False) %}
salt-master:
  service.dead:
    - enable: False

salt-syndic:
  service.dead:
    - enable: False
{% endif %}
