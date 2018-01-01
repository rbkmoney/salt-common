# -*- mode: yaml -*-
include:
  - gentoo

python3:
  pkg.latest:
    - name: dev-lang/python:3.5
    - slot: '3.5'
    - watch:
      - augeas: manage-make-conf

use-python3.5:
  file.append:
    - name: /etc/portage/profile/use.mask
    - text: "-python_targets_python3_5"
