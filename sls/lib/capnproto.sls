dev-libs/capnproto:
  portage_config.flags:
    - accept_keywords: ['~*']
  package.latest:
    - version: '[ssl]'
    - require:
      - portage_config: dev-libs/capnproto

