# -*- mode: yaml -*-
include:
  - gentoo

python3:
  pkg.latest:
    - name: dev-lang/python:3.5
    - slot: '3.5'
    - watch:
      - augeas: manage-make-conf
