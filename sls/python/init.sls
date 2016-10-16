# -*- mode: yaml -*-
include:
  - python.python2
  - python.python3

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: 'python3.4'

app-admin/python-updater:
  pkg.purged
