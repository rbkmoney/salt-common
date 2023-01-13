/etc/systemd/system-preset/00-disable-all.preset:
  file.managed:
    - contents: |
        # Managed by Salt
        disable *
    - user: root
    - group: root
    - mode: 644
