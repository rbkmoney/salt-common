include:
  - python.python3

pkg_python-config:
  pkg.latest:
    - pkgs:
      - dev-lang/python-exec
      - app-eselect/eselect-python

app-admin/python-updater:
  pkg.purged
