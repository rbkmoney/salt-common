{% import 'pkg/common' as pkg %}
include:
{% if grains.os == 'Gentoo' %}
  - gentoo.portage.packages
{% endif %}

logrotate:
  pkg.latest:
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - app-admin/logrotate
    - require:
      - file: gentoo.portage.packages
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - logrotate
