{% set collectd = salt.pillar.get('collectd', {}) -%}
{% set p_network = collectd.get('network', False) -%}
{% set extra_plugins = collectd.get('extra-plugins', []) %}
{% set extra_plugin_config = collectd.get('extra-plugin-config', []) %}
collectd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/conf.d/collectd
      - file: /etc/collectd/collectd.conf
      - file: /etc/collectd/types.db
      - file: /etc/collectd/conf.d/

/etc/conf.d/collectd:
  file.managed:
    - source: salt://collectd/files/collectd.confd
    - mode: 644
    - user: root
    - group: root

/etc/collectd:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: collectd

/etc/collectd/collectd.conf:
  file.managed:
    - source: salt://collectd/files/collectd.conf.tpl
    - template: jinja
    - defaults:
        virtual_machine: {{ salt['grains.get']('virtual', False) }}
        nfs_server: {{ salt['grains.get']('nfs_server', False) }}
    - mode: 640
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd
      - file: /etc/collectd/types.db

/etc/collectd/types.db:
  file.managed:
    - source: salt://collectd/files/types.db
    - mode: 644
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd

{% if p_network.get('users', False) %}
/etc/collectd/collectd.passwd:
  file.managed:
    - source: salt://collectd/files/collectd.passwd
    - template: jinja
    - mode: 640
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd
    - watch_in:
      - service: collectd
{% endif %}

/etc/collectd/conf.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: collectd

{% if extra_plugin_config.get('jmx', False) %}
/etc/collectd/conf.d/10-jmx.conf:
    - source: salt://collectd/files/conf.d/10-jmx.conf
    - mode: 640
    - user: root
    - group: collectd
    - require:
      - file: /etc/collectd/conf.d/
    - watch_in:
      - service: collectd
{% endif %}
