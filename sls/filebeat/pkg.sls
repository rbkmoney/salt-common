{% set filebeat_version = salt['pillar.get']('filebeat:version', '~>=6.3') %}
{% set filebeat_packaged = salt['pillar.get']('filebeat:packaged', True) %}
{% if not filebeat_packaged %}
include:
  - go
{% endif %}

app-admin/filebeat:
  pkg.installed:
    - version: "{{ filebeat_version }}"
    {% if filebeat_packaged %}
    - binhost: force
    {% endif %}

'paxctl-ng-filebeat':
  cmd.run:
    - name: 'setfattr -n user.pax.flags -v "em" /usr/bin/filebeat'
    - unless: 'test $(getfattr -n user.pax.flags /usr/bin/filebeat --only-values) == "em"'
    - watch:
      - pkg: app-admin/filebeat

/var/lib/filebeat/module/:
  file.recurse:
    - source: salt://filebeat/files/module/
    - file_mode: 640
    - dir_mode: 750
    - user: root
    - group: root
