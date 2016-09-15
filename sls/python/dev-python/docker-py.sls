include:
  - python.dev-python.websocket-client
  - python.dev-python.backports-ssl-match-hostname

docker-py:
  pkg.installed:
    - pkgs:
      - dev-python/docker-py: "~1.9.0"
    - require:
      - portage_config: docker-py
  portage_config.flags:
    - name: dev-python/docker-py
    - accept_keywords:
      - "~*"
