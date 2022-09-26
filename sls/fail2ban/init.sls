include:
  - .pkg

/etc/fail2ban/fail2ban.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/fail2ban.conf.tpl
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/fail2ban/filter.d/openvpn-otp-auth.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/filter.d/openvpn-otp-auth.conf
    - user: root
    - group: root
    - mode: 644

/etc/fail2ban/jail.d/salt.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/jail.d.tpl
    - template: jinja
    - user: root
    - group: root
    - mode: 644

fail2ban:
  service.running:
    - enable: True
    - watch:
      - pkg: net-analyzer/fail2ban
      - file: /etc/fail2ban/fail2ban.conf
      - file: /etc/fail2ban/jail.d/salt.conf
      - file: /etc/fail2ban/filter.d/openvpn-otp-auth.conf
