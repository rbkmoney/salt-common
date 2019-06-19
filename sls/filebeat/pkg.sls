{% import 'pkg/common' as pkg %}
app-admin/filebeat:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-admin/filebeat') }}
  {{ pkg.gen_portage_config('app-admin/filebeat', watch_in={'pkg': 'app-admin/filebeat'})|indent(8) }}

/var/lib/filebeat/module/:
  file.recurse:
    - source: salt://filebeat/files/module/
    - file_mode: 640
    - dir_mode: 750
    - user: root
    - group: root
