{% import 'pkg/common' as pkg %}
include:
  - lib.libc
  {% if grains.os == 'Gentoo' %}
  - python
  {% endif %}

app-containers/docker:
  pkg.installed:
    - reload_modules: true
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('app-containers/docker') }}
      - {{ pkg.gen_atom('dev-python/docker') }}
      {% elif grains.os_family == 'Debian' %}
      - docker.io
      - python3-docker
      {% endif %}
    - require:
      {{ libc.pkg_dep() }}
