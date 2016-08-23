# -*- mode: yaml -*-
include:
  - python.python2
  - python.python3

python-updater:
  cmd.wait:
    - name: '/usr/sbin/python-updater'
    - watch:
      - pkg: python2

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: 'python3.4'
