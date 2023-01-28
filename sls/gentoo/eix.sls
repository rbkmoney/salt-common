app-portage/eix:
  pkg.latest

/var/cache/eix/:
  file.directory:
    - create: True
    - mode: 775
    - user: portage
    - group: portage
    - require_in:
      - pkg: app-portage/eix

/etc/portage/postsync.d/eix-update:
  file.symlink:
    - target: /usr/bin/eix-update
    - makedirs: True
    - user: root
    - group: portage
    - require:
      - pkg: app-portage/eix
