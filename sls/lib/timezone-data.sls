{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

sys-libs/timezone-data:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('sys-libs/timezone-data') }}
      {% elif grains.os_family == 'Debian' %}
      - tzdata
      {% endif %}
    {% if grains.os == 'Gentoo' %}
    - require:
      - file: gentoo.portage.packages
    {% endif %}
