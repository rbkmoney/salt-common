# TODO: переместить конфигурацию в gpp, стейт удалить
net-libs/libhtp:
  portage_config.flags:
    - accept_keywords:
      - ~*
  pkg.latest:
    - require:
      - portage_config: net-libs/libhtp
