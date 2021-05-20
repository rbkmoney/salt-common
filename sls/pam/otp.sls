{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc
  - users

pam_otp:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('sys-auth/oath-toolkit') }}
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}

/etc/security/access-passless.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/access-passless.conf
    - mode: '0600'
    - user: root
    - group: root
    - require:
      - group: passless

/var/lib/pam_ssh/users.otp:
  file.managed:
    - source: salt://{{ slspath }}/files/users.otp.tpl
    - mode: '0600'
    - user: root
    - group: root
    - template: jinja
    - makedirs: True
    - defaults:
        users: {{ pillar['users']['present'] }}
    - require:
      - pkg: pam_otp

sshd_pam1:
  augeas.change:
    - context: /files/etc/pam.d/sshd
    - changes:
      - ins 01 before "*[type='auth'][control='include'][module='system-remote-login']"
      - set /01/type auth
      - set /01/control "[success=done default=ignore]"
      - set /01/module pam_access.so
      - set /01/argument[1] "accessfile=/etc/security/access-passless.conf"
    - unless: grep -v "^#" /etc/pam.d/sshd | grep pam_access.so
    - require:
      - file: /var/lib/pam_ssh/users.otp
      - file: /etc/security/access-passless.conf

sshd_pam2:
  augeas.change:
    - context: /files/etc/pam.d/sshd
    - changes:
      - ins 02 before "*[type='auth'][control='include'][module='system-remote-login']"
      - set /02/type auth
      - set /02/control "sufficient"
      - set /02/module pam_oath.so
      - set /02/argument[1] "usersfile=/var/lib/pam_ssh/users.otp"
    - unless: grep -v "^#" /etc/pam.d/sshd | grep pam_oath.so
    - require:
      - augeas: sshd_pam1

{% if grains.selinux is defined and grains.selinux.enabled == True %}
restorecon -Frv /var/lib/pam_ssh:
  cmd.run:
    - onchanges:
      - file: /var/lib/pam_ssh/users.otp
{% endif %}
