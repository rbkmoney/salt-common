make_conf:
  features:
    - xattr
    - sandbox
    - userfetch
    - parallel-fetch
    - parallel-install
    - clean-logs
    - compress-build-logs
    - unmerge-logs
    - splitdebug
    - compressdebug
    - fail-clean
    - unmerge-orphans
    - getbinpkg
    - -news
  other:
      USE_SALT: "emacs smp multitarget sqlite sctp xattr syslog logrotate ssl openssl vhosts symlink device-mapper bash-completion -gnutls -tcpd"
