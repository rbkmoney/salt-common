include:
  - python.dev-python.python-gnupg
  - python.dev-python.dnspython
  - python.dev-python.pyasn1

dev-python/sleekxmpp:
  portage_config.flags:
    - accept_keywords:
      - "~*"
  pkg.latest:
    - require:
      - portage_config: dev-python/sleekxmpp
      - pkg: dev-python/python-gnupg
      - pkg: dev-python/dnspython
      - pkg: dev-python/pyasn1
      - pkg: dev-python/pyasn1-modules
