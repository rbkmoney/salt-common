include:
  - python.python39

eselect-python:
  eselect.set:
    - name: python
    - target: 'python3.9'
    - require:
      - pkg: python39

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: 'python3.9'
    - require:
      - pkg: python39

pkg_python-config:
  pkg.latest:
    - pkgs:
      - dev-lang/python-exec
      - app-eselect/eselect-python

app-admin/python-updater:
  pkg.purged
