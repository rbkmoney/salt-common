{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

nagios-plugins:
  pkg.purged:
    - name: net-analyzer/nagios-plugins

monitoring-plugins:
  pkg.installed:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('net-analyzer/monitoring-plugins') }}
      {% elif grains.os_family == 'Debian' %}
      - monitoring-plugins-basic
      {% endif %}
    - require:
      - pkg: nagios-plugins
      {% if grains.os == 'Gentoo' %}
      - file: gentoo.portage.packages      
      {% endif %}
