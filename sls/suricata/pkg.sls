# TODO: флаги и кврд в gpp
net-analyzer/suricata:
  pkg.installed:
    - version: '~>=4.0.4[af-packet,nfqueue,control-socket,logrotate,-rules]'
  portage_config.flags:
    - accept_keywords: ["~*"]
