include:
  - java.icedtea3

jenkins_pkg:
  pkg.installed:
    - pkgs:
      - dev-util/jenkins-bin: '~>=2.97'
    - require:
      - pkg: icedtea3
