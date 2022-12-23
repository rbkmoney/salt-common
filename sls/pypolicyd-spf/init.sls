{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

mail-filter/pypolicyd-spf:
  pkg.latest:
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - mail-filter/spf-engine
      - dev-python/pyspf
    - require:
      - file: gentoo.portage.packages        
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - python3-spf
      - python3-spf-engine
      - postfix-policyd-spf-python
    {% endif %}
