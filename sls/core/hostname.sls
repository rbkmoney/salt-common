# -*- mode: yaml -*-
/etc/conf.d/hostname:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        # Managed by Salt
        # Set to the hostname of this machine
        hostname="{{ grains['fqdn'] }}"

hostname-restart:
  cmd.wait:
    - name: 'service hostname restart'
    - watch:
      - file: /etc/conf.d/hostname
