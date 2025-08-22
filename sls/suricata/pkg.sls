{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

net-analyzer/suricata:
  {% if grains.os == 'Gentoo' %}
  pkg.installed:
    - pkgs: 
      - {{ pkg.gen_atom('net-analyzer/suricata') }}
    - require:
      {{ libc.pkg_dep() }}
  {% elif grains.os_family == 'Debian' %}
  {% set pkg_prefix = 'apt:packages:suricata:' %}
  {% set suricata_version = salt.pillar.get(pkg_prefix + 'version', '') %}
  {% set hold_default = True if suricata_version else False %}
  {% if suricata_version %}
  pkg.installed:
  {% else %}
  pkg.latest:
  {% endif %}
    - pkgs:
      - suricata: {{ suricata_version }}
    - hold: {{ salt.pillar.get(pkg_prefix + 'hold', hold_default) }}
    - update_holds: {{ salt.pillar.get(pkg_prefix + 'update_holds', hold_default) }}
    - refresh: true
  {% endif %}
