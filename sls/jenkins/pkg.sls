include:
  - java.icedtea3

jenkins_pkg:
  pkg.installed:
    - pkgs:
      - dev-util/jenkins-bin: '~>=2.44'
    - require:
      - pkg: icedtea3
