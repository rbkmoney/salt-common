/etc/containerd/:
  file.directory:
    - create: True
    - user: root
    - group: root
    - mode: 755

/etc/containerd/config.toml:
  file.serialize:
    - dataset_pillar: containerd:conf
    - formatter: tomlmod
    - user: root
    - group: root
    - mode: 644

containerd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/containerd/
      - file: /etc/containerd/config.toml
