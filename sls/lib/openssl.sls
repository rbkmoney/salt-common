{% import 'pkg/common' as pkg %}
{% if grains['os'] == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

dev-libs/openssl:
  {% if grains['os'] == 'Gentoo' %}
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('dev-libs/openssl') }}
  {% elif grains['os_family'] == 'Debian' %}
  {% set pkg_prefix = 'apt:packages:openssl:' %}
  {% set openssl_version = salt.pillar.get(pkg_prefix + 'version', '') %}
  {% set libssl3_version = salt.pillar.get('apt:packages:libssl3:version', openssl_version) %}
  {% set hold_default = True if openssl_version else False %}
  {% if openssl_version %}
  pkg.installed:
  {% else %}
  pkg.latest:
  {% endif %}
    - pkgs:
      - openssl: {{ openssl_version }}
      - libssl3: {{ libssl3_version }}
    - hold: {{ salt.pillar.get(pkg_prefix + 'hold', hold_default) }}
    - update_holds: {{ salt.pillar.get(pkg_prefix + 'update_holds', hold_default) }}
  {% endif %}
