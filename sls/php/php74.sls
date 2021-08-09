{% import 'pkg/common' as pkg %}
include:
  - gentoo.makeconf
  - gentoo.portage.packages
  
php74:
  pkg.latest:
    - name: dev-lang/php
    - slot: '7.4'
    - require:
      - augeas: manage-make-conf
      - file: gentoo.portage.packages