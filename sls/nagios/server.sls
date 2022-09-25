{% set nagios = salt['pillar.get']('nagios') -%}
{% set objects_remote_uri = salt['pillar.get']('nagios:objects:remote') -%}
include:
  - users
  - nagios.server-pkg

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
    - source: salt://nagios/files/nagios.cfg
    - template: jinja
    - mode: 644
    - user: nagios
    - group: nagios
    - require:
      - file: /etc/nagios/
    
/etc/nagios/resource.cfg:
  file.managed:
    - source: salt://nagios/files/resource.cfg.tpl
    - template: jinja
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

/var/lib/nagios/home/nagios/.ssh/config:
  file.managed:
    - source: salt://nagios/files/ssh-config
    - mode: 750
    - user: nagios
    - group: nagios

/var/lib/nagios/home/nagios/.ssh/nagios-hosts-access-key:
  file.managed:
    - source: salt://ssl/openssh-privkey.tpl
    - template: jinja
    - context:
        privkey_key: nagios-hosts-access
    - mode: 600
    - user: nagios
    - group: nagios

/var/lib/nagios/spool/:
  file.directory:
    - create: True
    - user: nagios
    - group: nagios
    - mode: 750
    - require:
      - user: nagios

/var/lib/nagios/spool/checkresults/:
  file.directory:
    - create: True
    - user: nagios
    - group: nagios
    - mode: 750
    - require:
      - file: /var/lib/nagios/spool/

/var/lib/nagios/spool/graphios/:
  file.directory:
    - create: True
    - user: nagios
    - group: nagios
    - mode: 750
    - require:
      - file: /var/lib/nagios/spool/

nagios:
  service.running:
    - enable: True
    - watch:
      - pkg: nagios_pkg
      - user: nagios
      - file: /etc/nagios/
      - file: /etc/nagios/nagios.cfg
      - file: /var/lib/nagios/spool/
      - file: /var/lib/nagios/spool/checkresults/
      - file: /var/lib/nagios/spool/graphios/

nagios-reload:
  # This is for watch_in reloads
  service.running:
    - name: nagios
    - reload: True
    - watch:
      - git: /etc/nagios/objects/
      - file: /etc/nagios/resource.cfg
