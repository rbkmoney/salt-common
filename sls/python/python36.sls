include:
  - gentoo.makeconf

python36:
  pkg.latest:
    - name: dev-lang/python
    - slot: '3.6'
    - watch:
      - augeas: manage-make-conf
