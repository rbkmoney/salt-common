include:
  - .pkg
  - .conf

docker:
  service.running:
    - enable: True
    - sig: dockerd
    - init_delay: 25
    - watch:
      - pkg: app-containers/docker
      - file: /etc/conf.d/docker
      - file: /etc/docker/daemon.json

docker.login:
  module.run:
    - docker.login:
