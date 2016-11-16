{% set nagios = salt['pillar.get']('nagios') -%}
{% set objects_remote_uri = salt['pillar.get']('nagios:objects:remote') -%}
include:
  - users

/etc/nagios/:
  file.directory:
    - create: True
    - mode: 755
    - user: nagios
    - group: nagios
    - require:
      - user: nagios
    
/etc/nagios/nagios.cfg:
  file.managed:
    - source: salt://nagios/nagios.cfg
    - template: jinja
    - mode: 644
    - user: nagios
    - group: nagios
    - require:
      - file: /etc/nagios/
    
/etc/nagios/resource.cfg:
  file.managed:
    - source: salt://nagios/resource.cfg
    - mode: 600
    - user: nagios
    - group: nagios
    - require:
      - file: /etc/nagios/

/root/.ssh/nagios-objects-access:
  file.managed:
    - source: salt://ssl/openssh-privkey.tpl
    - template: jinja
    - context:
        privkey_key: nagios-objects-access
    - mode: 600
    - user: root

/etc/nagios/objects/:
  file.directory:
    - create: True
    - user: nagios
    - group: nagios
    - file_mode: 640
    - dir_mode: 750
  git.latest:
    - name: {{ objects_remote_uri }}
    - target: /etc/nagios/objects
    - rev: master
    - force_clone: True
    - force_checkout: True
    - identity: /root/.ssh/nagios-objects-access
    - require:
      - file: /root/.ssh/nagios-objects-access

/var/nagios/home/.ssh/:
  file.directory:
    - create: True
    - user: nagios
    - group: nagios
    - mode: 750
    - require:
      - user: nagios

/var/nagios/home/.ssh/config:
  file.managed:
    - source: salt://nagios/ssh-config
    - mode: 750
    - user: nagios
    - group: nagios

/var/nagios/home/.ssh/nagios-hosts-access-key:
  file.managed:
    - source: salt://ssl/openssh-privkey.tpl
    - template: jinja
    - context:
        privkey_key: nagios-hosts-access
    - mode: 600
    - user: nagios
    - group: nagios

nagios:
  service.running:
    - enable: True
    - watch:
      - user: nagios
      - file: /etc/nagios/
      - file: /etc/nagios/nagios.cfg

nagios-reload:
  # This is for watch_in reloads
  service.running:
    - name: nagios
    - reload: True
    - watch:
      - git: /etc/nagios/objects/
      - file: /etc/nagios/resource.cfg
