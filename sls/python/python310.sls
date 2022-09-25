{% import 'pkg/common' as pkg %}
include:
  - gentoo.makeconf
  - gentoo.portage.packages

python310:
  pkg.latest:
    - name: dev-lang/python
    - slot: '3.10'
    - require:
      - augeas: manage-make-conf
      - file: gentoo.portage.packages
