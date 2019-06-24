{% import 'pkg/common' as pkg %}
include:
  - vcs.git

sys-apps/portage:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('sys-apps/portage') }}
  {{ pkg.gen_portage_config('sys-apps/portage', watch_in={'pkg': 'sys-apps/portage'}, reload_modules=True)|indent(8) }}

app-portage-purged:
  pkg.purged:
    - pkgs:
      - app-portage/epkg

/etc/portage/repos.conf/:
  file.directory:
    - mode: 755
    - user: root
    - group: root

/etc/portage/profile/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/portage/env/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

