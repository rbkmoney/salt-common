dev-libs/capnproto:
  portage_config.flags:
    - accept_keywords: ['~*']
  pkg.latest:
    - version: '[ssl]'
    - require:
      - portage_config: dev-libs/capnproto

