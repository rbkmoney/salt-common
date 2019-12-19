include:
  - gentoo.makeconf

python2:
  pkg.latest:
    - name: dev-lang/python:2.7
    - slot: '2.7'
    - watch:
      - augeas: manage-make-conf
