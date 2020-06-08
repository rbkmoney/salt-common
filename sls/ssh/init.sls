include:
  - lib.ldns
  - lib.sctp
  - ssh.pkg
  - ssh.config

sshd:
  service.running:
    - enable: True
    - watch:
      - pkg: openssh
      - pkg: ldns
      - pkg: lksctp-tools
      - file: /etc/ssh/sshd_config
      - file: /etc/ssh/sshd_config.d/group-sftponly.conf
