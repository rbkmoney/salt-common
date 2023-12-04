{% set nagios = salt['pillar.get']('nagios') -%}
{% set objects_remote_uri = salt['pillar.get']('nagios:objects:remote') -%}
{% set var_dir = salt.pillar.get("nagios:conf:dirs:var", "/var/lib/nagios") %}
{% set conf_dir = salt.pillar.get("nagios:conf:dirs:conf", "/etc/nagios") %}
{% set conf_main = salt.pillar.get("nagios:conf:main", {}) %}
{% set nagios_home = {{ var_dir }} + "/home" %}
include:
  - users
  - nagios.server-pkg

{{ conf_dir }}/:
  file.directory:
    - create: True
    - mode: 755
    - user: nagios
    - group: nagios
    - require:
      - user: nagios
    
{{ conf_dir }}/nagios.cfg:
  file.managed:
    - source: salt://nagios/files/nagios.cfg.tpl
    - template: jinja
    - mode: 644
    - user: nagios
    - group: nagios
    - require:
      - file: {{ conf_dir }}/
    
{{ conf_dir }}/resource.cfg:
  file.managed:
    - source: salt://nagios/files/resource.cfg.tpl
    - template: jinja
    - mode: 600
    - user: nagios
    - group: nagios
    - require:
      - file: {{ conf_dir }}/

/root/.ssh/nagios-objects-access:
  file.managed:
    - source: salt://ssl/openssh-privkey.tpl
    - template: jinja
    - context:
        privkey_key: nagios-objects-access
    - mode: 600
    - user: root

{{ conf_dir }}/objects/:
  file.directory:
    - create: True
    - user: nagios
    - group: nagios
    - file_mode: 640
    - dir_mode: 750
  git.latest:
    - name: {{ objects_remote_uri }}
    - target: {{ conf_dir }}/objects
    - rev: master
    - force_clone: True
    - force_checkout: True
    - identity: /root/.ssh/nagios-objects-access
    - require:
      - file: /root/.ssh/nagios-objects-access

{{ nagios_home }}/.ssh/config:
  file.managed:
    - source: salt://nagios/files/ssh-config
    - mode: 750
    - user: nagios
    - group: nagios

{{ nagios_home }}/.ssh/nagios-hosts-access-key:
  file.managed:
    - source: salt://ssl/openssh-privkey.tpl
    - template: jinja
    - context:
        privkey_key: nagios-hosts-access
    - mode: 600
    - user: nagios
    - group: nagios

{{ var_dir }}/rw/:
  file.directory:
    - create: True
    - user: nagios
    - group: nagios
    - mode: 6755
    - require:
      - user: nagios

{{ var_dir }}/spool/:
  file.directory:
    - create: True
    - user: nagios
    - group: nagios
    - mode: 750
    - require:
      - user: nagios

{{ var_dir }}/spool/checkresults/:
  file.directory:
    - create: True
    - user: nagios
    - group: nagios
    - mode: 750
    - require:
      - file: {{ var_dir }}/spool/

{% if False %}
{{ var_dir }}/spool/graphios/:
  file.directory:
    - create: True
    - user: nagios
    - group: nagios
    - mode: 750
    - require:
      - file: {{ var_dir }}/spool/
{% endif %}

nagios:
  service.running:
    - enable: True
    {% if grains.os_family == 'Debian' %}
    - name: nagios4
    {% endif %}
    - watch:
      - pkg: nagios_pkg
      - user: nagios
      - file: {{ conf_dir }}/
      - file: {{ conf_dir }}/nagios.cfg
      - file: {{ var_dir }}/rw/
      - file: {{ var_dir }}/spool/
      - file: {{ var_dir }}/spool/checkresults/
      {% if False %}
      - file: {{ var_dir }}/spool/graphios/
      {% endif %}

nagios-reload:
  # This is for watch_in reloads
  service.running:
    {% if grains.os_family == 'Debian' %}
    - name: nagios4
    {% else %}
    - name: nagios
    {% endif %}
    - reload: True
    - watch:
      - git: {{ conf_dir }}/objects/
      - file: {{ conf_dir }}/resource.cfg
