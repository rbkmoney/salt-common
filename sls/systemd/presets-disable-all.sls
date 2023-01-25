include:
  - systemd.common

/etc/systemd/system-preset/00-disable-all-services.preset:
  file.managed:
    - contents: |
        # Managed by Salt
        disable *.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/systemd/system-preset/
