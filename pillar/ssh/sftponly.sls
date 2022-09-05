ssh:
  sshd_config:
    extra:
      Match group sftponly:
        ChrootDirectory: "/home/%u"
        X11Forwarding: "no"
        AllowTcpForwarding: "no"
        ForceCommand: internal-sftp

groups:
  present:
    sftponly: {}
