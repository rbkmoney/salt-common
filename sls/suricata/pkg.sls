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
  pkg.installed:
    - version: '~>=4.0.4[af-packet,nfqueue,control-socket,logrotate,-rules]'
    - require:
      - pkg: logrotate
      - pkg: net-libs/libhtp
  portage_config.flags:
    - accept_keywords: ["~*"]
