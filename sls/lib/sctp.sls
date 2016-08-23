# -*- mode: yaml -*-

lksctp-tools:
  pkg.latest:
    - pkgs:
      - net-misc/lksctp-tools
  {% if grains['osarch'].startswith('arm') %}
  portage_config.flags:
    - name: net-misc/lksctp-tools
    - accept_keywords:
      - ~arm
    - watch_in:
      - pkg: lksctp-tools
  {% endif %}
