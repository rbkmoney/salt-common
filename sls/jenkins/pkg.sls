{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages  
  - java.icedtea-bin

jenkins_pkg:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('dev-util/jenkins-bin') }}
    - require:
      - pkg: dev-java/icedtea-bin
      - file: gentoo.portage.packages      
