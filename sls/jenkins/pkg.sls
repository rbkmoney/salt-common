{% import 'pkg/common' as pkg %}
include:
  - java.icedtea3
  - gentoo.portage.packages  

jenkins_pkg:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('dev-util/jenkins-bin') }}
    - require:
      - pkg: icedtea3
      - file: gentoo.portage.packages      
