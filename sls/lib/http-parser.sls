# TODO: latest
{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}
{% set http_parser_version = salt['pillar.get']('http-parser:version', '~>=2.9.0') %}

net-libs/http-parser:
  pkg.latest:
    - oneshot: True
    - version: "{{ http_parser_version }}"
    {% if libs_packaged %}
    - binhost: force
    {% else %}
    - binhost: try
    {% endif %}
