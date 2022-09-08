{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
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
    {% endif %}
