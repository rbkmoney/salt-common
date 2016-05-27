include:
  - core.ldns
  - core.sctp
  - ssl.openssl
  - ssh.pkg
  - ssh.config

sshd:
  service.running:
    - enable: True
    - watch:
      - pkg: openssh
      - pkg: ldns
      - pkg: lksctp-tools
      - pkg: openssl
      - file: /etc/ssh/sshd_config
