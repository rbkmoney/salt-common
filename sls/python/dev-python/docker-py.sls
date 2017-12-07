include:
  - python.dev-python.websocket-client
  - python.dev-python.backports-ssl-match-hostname
  - python.dev-python.docker-pycreds

unmask-docker-py-2.x:
  portage_config.flags:
    - name: '>=dev-python/docker-py-2.0'
    - mask: False

docker-py:
  pkg.installed:
    - pkgs:
      - dev-python/docker-py: "~>=2.4"
    - require:
      - portage_config: unmask-docker-py-2.x
