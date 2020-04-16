sshd_pam1:
  augeas.change:
    - context: /files/var/lib/pam_ssh/users.otp
    - lens: hosts.lns
    - changes:
      - set ipaddr HOTP/T30/6
      - set canonical root
      - set alias[1] '-'
      - set alias[2] '1ab6b4cafc9d1982410ab762ba33b4'
    - unless: grep -E '^HOTP/T30/6.*root.*1ab6b4cafc9d1982410ab762ba33b4'
