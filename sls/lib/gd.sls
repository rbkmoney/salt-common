{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}
media-libs/gd:
  pkg.installed:
    - version:  ">=2.2.5[jpeg,png,tiff,webp,truetype]"
    {% if libs_packaged %}
    - binhost: force
    {% endif %}
