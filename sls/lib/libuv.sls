{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}
{% set libuv_version = salt['pillar.get']('libuv:version', '~>=1.25.0') %}

dev-libs/libuv:
  pkg.latest:
    - version: "{{ libuv_version }}"
    {% if libs_packaged %}
    - binhost: force
    {% else %}
    - binhost: try
    {% endif %}
