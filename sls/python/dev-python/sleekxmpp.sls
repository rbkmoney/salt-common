include:
  - python.dev-python.python-gnupg

dev-python/sleekxmpp:
  portage_config.flags:
    - accept_keywords:
      - "~*"
  pkg.latest:
    - require:
      - portage_config: dev-python/sleekxmpp
      - pkg: dev-python/python-gnupg
