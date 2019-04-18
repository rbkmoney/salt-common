include:
  - vcs.git

sys-apps/portage:
  pkg.latest:
    - pkgs:
      - sys-apps/portage: "[xattr,-rsync-verify]"
    - watch:
      - portage_config: sys-apps/portage
  portage_config.flags:
    - accept_keywords: []
    - use:
      - xattr
      - -rsync-verify
    - reload_modules: true

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

