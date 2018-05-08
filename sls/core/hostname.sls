/etc/conf.d/hostname:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        # Managed by Salt
        # Set to the hostname of this machine
        hostname="{{ grains['fqdn'] }}"

hostname:
  service.running:
    - watch:
      - file: /etc/conf.d/hostname
