include:
{% if grains.os == 'Gentoo' %}
  - lib.ldns
  - lib.sctp
{% endif %}
  - ssh.pkg
  - ssh.config

sshd:
  service.running:
    - enable: True
    - watch:
      - pkg: net-misc/openssh
{% if grains.os == 'Gentoo' %}
      - pkg: ldns
      - pkg: lksctp-tools
{% endif %}
      - file: /etc/ssh/sshd_config
      - file: /etc/ssh/sshd_config.d/group-sftponly.conf
