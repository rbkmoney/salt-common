include:
  - lib.libhtp

net-analyzer/suricata:
  portage_config.flags:
    - accept_keywords:
      - ~*
  pkg.latest:
    - pkgs:
      - net-analyzer/suricata: '[af-packet,control-socket]'
    - require:
      - pkg: net-libs/libhtp
