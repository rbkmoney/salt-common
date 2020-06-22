{% import 'pkg/common' as pkg %}
include:
  - gentoo.makeconf
  - gentoo.portage.packages

python37:
  pkg.latest:
    - name: dev-lang/python
    - slot: '3.7'
    - require:
      - augeas: manage-make-conf
      - file: gentoo.portage.packages
