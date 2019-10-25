{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - java.openjdk-bin11-system

/etc/init.d/kibana:
  file.managed:
    - source: salt://kibana/files/kibana.initd
    - mode: 755

www-apps/kibana-bin:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('www-apps/kibana-bin') }}
    - require:
      - file: gentoo.portage.packages


