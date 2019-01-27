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
    USE_SALT: "smp multitarget numa caps seccomp xattr sctp lzma logrotate sqlite -gnutls -tcpd"
    PYTHON_TARGETS: "python2_7 python3_6"
    PYTHON_SINGLE_TARGET: "python3_6"
