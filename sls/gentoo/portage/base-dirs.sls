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

