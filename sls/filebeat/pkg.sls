{% set filebeat_version = salt['pillar.get']('filebeat:version', '~>=6.3') %}
include:
  - go

filebeat_pkg:
  pkg.installed:
    - pkgs:
      - app-admin/filebeat: "{{ filebeat_version }}"

'paxctl-ng-filebeat':
  cmd.run:
    - name: 'setfattr -n user.pax.flags -v "em" /usr/bin/filebeat'
    - unless: 'test $(getfattr -n user.pax.flags /usr/bin/filebeat --only-values) == "em"'
    - watch:
      - pkg: filebeat_pkg

/var/lib/filebeat/module/:
  file.recurse:
    - source: salt://filebeat/files/module/
    - file_mode: 640
    - dir_mode: 750
    - user: root
    - group: root
