include:
  - gentoo.makeconf

python36:
  pkg.latest:
    - name: dev-lang/python:3.6
    - slot: '3.6'
    - watch:
      - augeas: manage-make-conf
