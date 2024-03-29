{% set collectd = salt.pillar.get('collectd', {}) -%}
{% set p_network = collectd.get('network', {}) -%}
{% set extra_plugins = collectd.get('extra-plugins', []) %}
{% set extra_plugin_config = collectd.get('extra-plugin-config', {}) %}
collectd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/collectd/collectd.conf
      - file: /etc/collectd/types.db
      - file: /etc/collectd/conf.d/
  user.present:
    - system: True
    - home: /var/lib/collectd
    - shell: /sbin/nologin

{% if grains['init'] == 'openrc' %}
/etc/init.d/collectd:
  file.managed:
    - source: salt://{{ slspath }}/files/collectd.init
    - mode: 755
    - user: root
    - group: root
    - watch_in:
      - service: collectd

/etc/conf.d/collectd:
  file.managed:
    - source: salt://{{ slspath }}/files/collectd.confd.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: collectd

{% elif grains['init'] == 'systemd' %}
/etc/systemd/system/collectd.service.d/override.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/collectd.service.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - makedirs: True
    - watch_in:
      - service: collectd

/etc/init.d/collectd: file.absent
/etc/conf.d/collectd: file.absent
{% endif %}

/etc/systemd/system/collectd.service: file.absent

/etc/collectd.conf: file.absent

/etc/collectd/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: collectd
    - require:
      - user: collectd

/etc/collectd/collectd.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/collectd.conf.tpl
    - template: jinja
    - defaults:
        virtual_machine: {{ salt.grains.get('virtual', False) }}
        nfs_server: {{ salt.grains.get('nfs_server', False) }}
    - mode: 640
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd/
      - file: /etc/collectd/types.db

/etc/collectd/types.db:
  file.managed:
    - source: salt://{{ slspath }}/files/types.db
    - mode: 644
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd/

{% if p_network.get('users', False) %}
/etc/collectd/collectd.passwd:
  file.managed:
    - source: salt://{{ slspath }}/files/collectd.passwd
    - template: jinja
    - mode: 640
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd/
    - watch_in:
      - service: collectd
{% endif %}

/etc/collectd/collectd.conf.d/: file.absent
/etc/collectd/collection.conf: file.absent

/etc/collectd/conf.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd/

/etc/collectd/conf.d/placeholder.conf:
  file.managed:
    - mode: 755
    - user: root
    - group: root
    - contents: ""
    - require:
      - file: /etc/collectd/conf.d/

/etc/collectd/conf.d/10-jmx.conf:
  {% if extra_plugin_config.get('jmx', False) %}
  file.managed:
    - source: salt://{{ slspath }}/files/conf.d/10-jmx.conf
    - mode: 640
    - user: root
    - group: collectd
  {% else %}
  file.absent:
  {% endif %}
    - require:
      - file: /etc/collectd/conf.d/
    - watch_in:
      - service: collectd

/etc/collectd/conf.d/20-python-consul-health.conf:
  {% if extra_plugin_config.get('consul_health_plugin', False) %}
  file.managed:
    - source: salt://{{ slspath }}/files/conf.d/20-python-consul-health.conf
    - mode: 640
    - user: root
    - group: collectd
  {% else %}
  file.absent:
  {% endif %}
    - require:
      - file: /etc/collectd/conf.d/
    - watch_in:
      - service: collectd

{% if extra_plugin_config.get('consul_health_plugin', False) %}
/usr/share/collectd/consul-health/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: collectd
    - require:
      - user: collectd
/usr/share/collectd/consul-health/consul_health_plugin.py:
  file.managed:
    - source: salt://{{ slspath }}/files/consul_health_plugin.py
    - mode: 640
    - user: root
    - group: collectd
    - require:
      - file: /usr/share/collectd/consul-health/
    - require_in:
      - file: /etc/collectd/conf.d/20-python-consul-health.conf
{% endif %}
