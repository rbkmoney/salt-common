{% import 'lib/libc.sls' as libc %}
include:
  - .pkg
  - .service

extend:
  {% set apcupsd = salt.pillar.get("apcupsd", {}) %}
  {% if 'instances' in apcupsd %}
  {% for instance in apcupsd["instances"] %}
  apcupsd.{{ instance }}:
    service.running:
    - watch:
      - pkg: sys-power/apcupsd
      {{ libc.pkg_dep() }}
  {% endfor %}
  {% else %}
  apcupsd:
    service.running:
    - watch:
      - pkg: sys-power/apcupsd
      {{ libc.pkg_dep() }}
  {% endif %}
