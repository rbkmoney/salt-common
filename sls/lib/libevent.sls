{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}

dev-libs/libevent:
  pkg.latest:
    {% if libs_packaged %}
    - binhost: force
    {% endif %}
