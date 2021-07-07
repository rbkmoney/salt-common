portage:
  sync_wait_one_day: True

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
    USE_SALT: "argon2 audit caps cgroups cracklib ecdsa efi filecaps json gnupg http2 iproute2 leaps_timezone logrotate lz4 lzma lzo multitarget netlink nettle nfsv4 nfsv41 numa openssl pcre16 sctp seccomp smp sqlite threads udev xattr xfs -X -bindist -dbus -gnutls -tcpd"
    CURL_SSL: "openssl"
    PYTHON_TARGETS: "python3_9"
    PYTHON_SINGLE_TARGET: "python3_9"
    ACCEPT_LICENSE: "*"
