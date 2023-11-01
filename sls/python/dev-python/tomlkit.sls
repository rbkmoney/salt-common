{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - python
  - gentoo.portage.packages
{% endif %}


dev-python/tomlkit:
  pkg.latest:
    - reload_modules: true
    {% if grains.os == 'Gentoo' %}
    - require:
      - file: gentoo.portage.packages
    - pkgs:
      - {{ pkg.gen_atom('dev-python/tomlkit') }}
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - python3-tomlkit
    {% endif %}
