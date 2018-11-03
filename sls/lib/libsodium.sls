{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}

dev-libs/libsodium:
  pkg.latest:
    {% if libs_packaged %}
    - binhost: force
    {% else %}
    - binhost: try
    {% endif %}

