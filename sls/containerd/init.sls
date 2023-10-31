include:
  - .pkg

containerd:
  service.running:
    - enable: True
    - watch:
      - pkg: app-containers/containerd
