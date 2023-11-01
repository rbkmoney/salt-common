include:
  - python.dev-python.tomlkit

/etc/containerd/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode: 755

/etc/containerd/config.toml:
  file.serialize:
    - dataset_pillar: containerd:conf
    - formatter: tomlkit
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: dev-python/tomlkit

containerd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/containerd/
      - file: /etc/containerd/config.toml
