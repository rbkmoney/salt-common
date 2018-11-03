{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}
dev-libs/glib:
  pkg.latest:
    - version: ">=2.50.3[mime]"
    {% if libs_packaged %}
    - binhost: force
    {% endif %}
