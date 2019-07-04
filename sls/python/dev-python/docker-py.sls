docker-py:
  pkg.latest:
    - name: dev-python/docker-py
    - require:
      - portage_config: unmask-docker-py-2.x
