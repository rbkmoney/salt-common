include:
  - gentoo

ruby21:
  pkg.latest:
    - name: 'dev-lang/ruby:2.1'
    - slot: '2.1'
    - watch:
      - augeas: manage-make-conf
