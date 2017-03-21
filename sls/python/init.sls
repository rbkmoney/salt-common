# -*- mode: yaml -*-
include:
  - python.python2
  - python.python3

app-eselect/eselect-python:
  portage_config.flags:
    - accept_keywords: []
  pkg.latest

dev-lang/python-exec:
  portage_config.flags:
    - accept_keywords: []
  pkg.latest

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: 'python3.4'
    - require:
      - pkg: app-eselect/eselect-python

app-admin/python-updater:
  pkg.purged
