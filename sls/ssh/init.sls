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
      - pkg: net-libs/ldns
      - pkg: net-misc/lksctp-tools
{% endif %}
      - file: /etc/ssh/sshd_config
