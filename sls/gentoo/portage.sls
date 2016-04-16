# -*- mode: yaml -*-
include:
  - core.git

sys-apps/portage:
  pkg.latest:
    - watch:
      - portage_config: sys-apps/portage
  portage_config.flags:
    - accept_keywords:
      - ~ARCH
    - use:
      - python3
      - xattr
      - git
    - watch_in:
      - cmd: emerge-changed-use

app-portage:
  pkg.latest:
    - pkgs:
      - app-portage/portage-utils
      - app-portage/gentoolkit
      - app-portage/eix
      - app-admin/webapp-config

app-portage-purged:
  pkg.purged:
    - pkgs:
      - app-portage/epkg

/etc/portage/postsync.d/q-reinitialize:
  file.managed:
    - mode: 755
    - replace: False

# rewrite this with consideration of read-only portage (on nfs)
/usr/portage:
  git.latest:
    - name: "git://git.bakka.su/gentoo-mirror"
    - target: /usr/portage
    - rev: master
    - force_clone: True
    - force_checkout: True

/etc/portage/repos.conf/:
  file.directory:
    - mode: 755
    - user: root
    - group: root
  git.latest:
    - name: "git://git.bakka.su/server-repos.conf"
    - target: /etc/portage/repos.conf
    - rev: master
    - force_clone: True
    - force_checkout: True

emerge-changed-use:
  cmd.wait:
    - name: '/usr/bin/emerge --quiet --changed-use @world'

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
