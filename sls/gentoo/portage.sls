# -*- mode: yaml -*-
include:
  - vcs.git

sys-apps/portage:
  pkg.latest:
    - pkgs:
      - sys-apps/portage: "[xattr,git]"
    - watch:
      - portage_config: sys-apps/portage
  portage_config.flags:
    - accept_keywords: []

app-portage-purged:
  pkg.purged:
    - pkgs:
      - app-portage/epkg

/etc/portage/postsync.d/q-reinitialize:
  file.managed:
    - mode: 755
    - replace: False

/etc/portage/repos.conf/:
  file.directory:
    - mode: 755
    - user: root
    - group: root

# emerge-preserved-rebuild:
#   cmd.run:
#     - name: '/usr/bin/emerge --quiet @preserved-rebuild'

# glsa-check-fix:
#   cmd.run:
#     - name: '/usr/bin/glsa-check --fix affected'

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

