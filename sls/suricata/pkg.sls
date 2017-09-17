include:
  - logrotate
  - lib.libhtp
# net-libs/libnet
# dev-libs/nss
# dev-libs/nspr
# dev-libs/libyaml
# dev-libs/jansson
# net-libs/libnetfilter_queue
net-analyzer/suricata:
  portage_config.flags:
    - accept_keywords:
      - ~*
  pkg.latest:
    - pkgs:
      - net-analyzer/suricata: '[af-packet,nfqueue,control-socket,logrotate]'
    - require:
      - pkg: logrotate
      - pkg: net-libs/libhtp
