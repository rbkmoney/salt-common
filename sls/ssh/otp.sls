{% import 'pkg/common' as pkg %}
google-authenticator-libpam:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('sys-auth/google-authenticator') }}

/var/lib/pam_ssh/users.otp:
  file.managed:
    - source: salt://{{ slspath }}/files/users.otp.tpl
    - mode: '0600'
    - user: root
    - group: root
    - template: jinja
    - makedirs: True
    - defaults:
      - users: {{ pillar[users][present] }}
    - require:
      - pkg: google-authenticator-libpam

sshd_pam:
  augeas.change:
    - context: /files/etc/pam.d/sshd
    - changes:
      - ins 01 before "*[type='auth'][control='include'][module='system-remote-login']"
      - set /01/type auth
      - set /01/control "[success=done new_authtok_reqd=done default=die]"
      - set /01/module pam_google_authenticator.so
      - set /01/arguments nullok secret=/var/lib/pam_ssh/users.otp
    - unless: grep -v "^#" /etc/pam.d/sshd | grep pam_google_authenticator.so
    - require:
      - file: /var/lib/pam_ssh/users.otp
