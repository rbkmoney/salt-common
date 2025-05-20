{% import 'pkg/common' as pkg %}
include:
{% if grains['os'] == 'Gentoo' %}
  - gentoo.portage.packages
{% elif grains['os_family'] == 'Debian' %}
  - elasticsearch.repo-apt
{% endif %}

app-admin/filebeat:
{% if grains['os'] == 'Gentoo' %}
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-admin/filebeat') }}
    - require:
      - file: gentoo.portage.packages
{% elif grains['os_family'] == 'Debian' %}
{% set pkg_prefix = 'apt:packages:filebeat:' %}
{% set beat_version = salt.pillar.get(pkg_prefix + 'version', '') %}
{% set hold_default = True if beat_version else False %}
{% if beat_version %}
  pkg.installed:
{% else %}
  pkg.latest:
{% endif %}
    - pkgs:
      - filebeat: {{ beat_version }}
    - hold: {{ salt.pillar.get(pkg_prefix + 'hold', hold_default) }}
    - update_holds: {{ salt.pillar.get(pkg_prefix + 'update_holds', hold_default) }}
    - require:
      - file: /etc/apt/sources.list.d/elastic.list
{% endif %}
