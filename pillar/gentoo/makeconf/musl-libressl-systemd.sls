make_conf:
  other:
    USE_SALT: "argon2 audit caps cgroups cracklib ecdsa efi filecaps json gnupg http2 iproute2 leaps_timezone logrotate lz4 lzma lzo multitarget netlink nettle nfsv4 nfsv41 numa openssl pcre16 sctp seccomp smp sqlite threads udev xattr xfs -X -bindist -dbus -gnutls -tcpd -openssl libressl"
    CURL_SSL: "libressl"
    PYTHON_TARGETS: "python3_7"
    PYTHON_SINGLE_TARGET: "python3_7"
    ACCEPT_LICENSE: "*"
