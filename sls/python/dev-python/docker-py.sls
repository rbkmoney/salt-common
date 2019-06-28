unmask-docker-py-2.x:
  portage_config.flags:
    - name: '>=dev-python/docker-py-2.0'
    - mask: False

docker-py:
  pkg.latest:
    - name: dev-python/docker-py
    - require:
      - portage_config: unmask-docker-py-2.x
