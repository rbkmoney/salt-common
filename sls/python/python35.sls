include:
  - gentoo.makeconf

python35:
  pkg.latest:
    - name: dev-lang/python
    - slot: '3.5'
    - watch:
      - augeas: manage-make-conf
