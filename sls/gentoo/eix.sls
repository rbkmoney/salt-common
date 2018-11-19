app-portage/eix:
  pkg.latest

/var/cache/eix/:
  file.directory:
    - create: True
    - mode: 755
    - user: portage
    - group: portage
