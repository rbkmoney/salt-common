dev-ruby/msgpack:
  portage_config.flags:
    - accept_keywords:
      - '~*'
  pkg.latest:
    - require:
      - portage_config: dev-ruby/msgpack
