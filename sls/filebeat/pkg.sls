{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

app-admin/filebeat:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-admin/filebeat') }}
    - require:
      - file: gentoo.portage.packages

/var/lib/filebeat/module/:
  file.recurse:
    - source: salt://filebeat/files/module/
    - file_mode: 640
    - dir_mode: 750
    - user: root
    - group: root
