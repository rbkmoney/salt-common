{% import 'pkg/common' as pkg %}
include:
  {% if grains.os == 'Gentoo' %}
  - python
  - gentoo.portage.packages
  {% elif grains.os_family == 'Debian' %}
  - lib.libc
  {% endif %}

app-containers/docker:
  pkg.installed:
    - reload_modules: true
    {% if grains.os == 'Gentoo' %}
    - require:
      - file: gentoo.portage.packages
    - pkgs:
      - {{ pkg.gen_atom('app-containers/docker') }}
      - {{ pkg.gen_atom('dev-python/docker') }}
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - docker.io
      - python3-docker
    {% endif %}

