# TODO: убрать насовсем, от пакета нет зависимостей
dev-python/colorama:
  pkg.installed:
    - require:
      - portage_config: dev-python/colorama
  portage_config.flags:
    - accept_keywords:
      - "~*"
