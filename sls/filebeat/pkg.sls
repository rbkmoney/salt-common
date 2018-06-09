filebeat_pkg:
  pkg.installed:
    - pkgs:
      - app-admin/filebeat: "~>=6.1.1"

'paxctl-ng-filebeat':
  cmd.run:
    - name: 'setfattr -n user.pax.flags -v "em" /usr/bin/filebeat'
    - unless: 'test $(getfattr -n user.pax.flags /usr/bin/filebeat --only-values) == "em"'
    - watch:
      - pkg: filebeat_pkg
