# -*- mode: yaml -*-
include:
  - gentoo

python3:
  pkg.latest:
    - name: dev-lang/python:3.4
    - slot: '3.4'
    - watch:
      - augeas: manage-make-conf

use-python3.5:
  file.append:
    - name: /etc/portage/profile/use.mask
    - text: "-python_targets_python3_5"

python3.5:
  pkg.removed:
    - name: dev-lang/python:3.5
    - slot: '3.5'
    - watch:
      - augeas: manage-make-conf

app-eselect/eselect-python:
  portage_config.flags:
    - accept_keywords: []

dev-lang/python-exec:
  portage_config.flags:
    - accept_keywords: []
