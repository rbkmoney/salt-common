{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}
sys-libs/cracklib:
  pkg.latest:
    {% if libs_packaged %}
    - binhost: force
    {% endif %}
