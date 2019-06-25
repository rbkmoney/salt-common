# TODO: make oneshot
{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}

net-libs/libmicrohttpd:
  pkg.latest:
    {% if libs_packaged %}
    - binhost: force
    {% else %}
    - binhost: try
    {% endif %}
