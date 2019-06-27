# TODO: уже не нужно, удалить
include:
  - python.dev-python.websocket-client
  - python.dev-python.backports-ssl-match-hostname

mask-docker-py-2.x:
  portage_config.flags:
    - name: '>=dev-python/docker-py-2.0'
    - mask: True

docker-py:
  pkg.installed:
    - pkgs:
      - dev-python/docker-py: "~>=1.10.6"
    - require:
      - portage_config: mask-docker-py-2.x
      - portage_config: docker-py
  portage_config.flags:
    - name: dev-python/docker-py
    - accept_keywords:
      - "~*"
