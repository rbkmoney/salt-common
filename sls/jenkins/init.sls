include:
  - jenkins.pkg

/etc/conf.d/jenkins:
  file.managed:
    - source: salt://jenkins/files/jenkins.confd.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root

jenkins:
  service.running:
    - name: jenkins
    - enable: True
    - watch:
      - pkg: jenkins_pkg
      - pkg: icedtea3
      - file: /etc/conf.d/jenkins
