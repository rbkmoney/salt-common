dev-ruby/concurrent-ruby:
  portage_config.flags:
    - accept_keywords:
      - '~*'
  pkg.latest:
    - require:
      - portage_config: dev-ruby/concurrent-ruby
