{% import 'pkg/common' as pkg %}
include:
  - gentoo.makeconf
  - gentoo.portage.packages

python2:
  pkg.latest:
    - name: dev-lang/python:2.7
    - slot: '2.7'
    - require:
      - augeas: manage-make-conf
      - file: gentoo.portage.packages
