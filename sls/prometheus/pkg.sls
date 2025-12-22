{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

app-metrics/prometheus:
{% if grains.os == 'Gentoo' %}
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-metrics/prometheus') }}
    - require:
      - file: gentoo.portage.packages
{% elif grains.os_family == 'Debian' %}
{% set pkg_prefix = 'apt:packages:prometheus:' %}
{% set prometheus_version = salt.pillar.get(pkg_prefix + 'version', '') %}
{% set hold_default = True if prometheus_version else False %}
{% if prometheus_version %}
  pkg.installed:
{% else %}
  pkg.latest:
{% endif %}
    - pkgs:
      - prometheus: {{ prometheus_version }}
    - hold: {{ salt.pillar.get(pkg_prefix + 'hold', hold_default) }}
    - update_holds: {{ salt.pillar.get(pkg_prefix + 'update_holds', hold_default) }}
{% endif %}
