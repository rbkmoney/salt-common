{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}

lksctp-tools:
  pkg.latest:
    - pkgs:
      - net-misc/lksctp-tools
    {% if libs_packaged %}
    - binhost: force
    {% endif %}
  {% if grains['osarch'].startswith('arm') %}
  portage_config.flags:
    - name: net-misc/lksctp-tools
    - accept_keywords:
      - ~arm
    - watch_in:
      - pkg: lksctp-tools
  {% endif %}
