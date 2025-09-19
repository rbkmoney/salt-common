include:
  - .minion-config
  - .selinux
  - .pkg

extend:
  /etc/salt/minion:
    file.serialize:
      - require:
        - pkg: app-admin/salt

{% if grains.get("init", "openrc") == "systemd" %}
/etc/systemd/system/salt-minion.service.d/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode: 755
    # - require:
    #   - file: /etc/systemd/system/


/etc/systemd/system/salt-minion.service.d/override.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 640
    - require:
      - file: /etc/systemd/system/salt-minion.service.d/
    - watch_in:
      - service: salt-minion
    - contents: |
        [Service]
        Restart=always
        RestartSec=10s
        # WatchdogSec=60s
        StartLimitIntervalSec=0
        StartLimitBurst=0
        StartLimitAction=none
{% else %}
/etc/systemd/system/salt-minion.service.d/override.conf:
  file.absent
{% endif %}

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

salt-api:
  service.dead:
    - enable: False
{% endif %}
