include:
  - python.python310

eselect-python:
  eselect.set:
    - name: python
    - target: 'python3.10'
    - require:
      - pkg: dev-lang/python-310

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: 'python3.10'
    - require:
      - pkg: dev-lang/python-310

pkg_python-config:
  pkg.latest:
    - pkgs:
      - dev-lang/python-exec
      - app-eselect/eselect-python

app-admin/python-updater:
  pkg.purged
