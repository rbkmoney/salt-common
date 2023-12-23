{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

monitoring-plugins:
  pkg.purged:
    - name: net-analyzer/monitoring-plugins

nagios-plugins:
  pkg.installed:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('net-analyzer/nagios-plugins') }}
      {% endif %}
    - require:
      - pkg: monitoring-plugins
      {% if grains.os == 'Gentoo' %}
      - file: gentoo.portage.packages
      {% endif %}
