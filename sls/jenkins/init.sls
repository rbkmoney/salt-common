include:
  - jenkins.pkg

jenkins:
  service.running:
    - name: jenkins
    - enable: True
    - watch:
      - pkg: jenkins_pkg
      - pkg: icedtea3
      
