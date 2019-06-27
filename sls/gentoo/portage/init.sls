{% import 'pkg/common' as pkg %}
include:
  - vcs.git
  - gentoo.portage.packages

sys-apps/portage:
  pkg.latest:
    - reload_modules: True
    - pkgs:
      - {{ pkg.gen_atom('sys-apps/portage') }}
    - require:
      - file: gentoo.portage.packages

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

