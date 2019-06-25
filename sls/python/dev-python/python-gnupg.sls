# TODO: убрать зависимости на стейт
dev-python/python-gnupg:
  portage_config.flags:
    - accept_keywords:
      - "~*"
  pkg.latest:
    - require:
      - portage_config: dev-python/python-gnupg
