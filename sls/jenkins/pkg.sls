{% import 'pkg/common' as pkg %}
include:
  - java.icedtea3

jenkins_pkg:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('dev-util/jenkins-bin') }}
    - require:
      - pkg: icedtea3
  {{ pkg.gen_portage_config('dev-util/jenkins-bin', watch_in={'pkg': 'jenkins_pkg'})|indent(8) }}

