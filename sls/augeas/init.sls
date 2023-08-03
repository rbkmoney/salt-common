{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

augeas:
  pkg.installed:
    - refresh: false
    - reload_modules: True
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('app-admin/augeas') }}
      - {{ pkg.gen_atom('dev-python/python-augeas') }}
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - libaugeas0
      - augeas-lenses
      - augeas-tools
      - python3-augeas
    {% endif %}
