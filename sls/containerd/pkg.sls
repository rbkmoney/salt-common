{% import 'pkg/common' as pkg %}
include:
  {% if grains.os == 'Gentoo' %}
  - python
  - gentoo.portage.packages
  {% elif grains.os_family == 'Debian' %}
  - lib.libc
  {% endif %}

app-containers/containerd:
  pkg.installed:
    - reload_modules: true
    {% if grains.os == 'Gentoo' %}
    - require:
      - file: gentoo.portage.packages
    - pkgs:
      - {{ pkg.gen_atom('app-containers/containerd') }}
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - containerd
    {% endif %}
