include:
  - .pkg
  - .conf

docker:
  service.running:
    - enable: True
    - sig: dockerd
    - init_delay: 25
    - watch:
      - pkg: app-emulation/docker
      - file: /etc/conf.d/docker
      - file: /etc/docker/daemon.json

docker.login:
  module.run:
    - docker.login:
