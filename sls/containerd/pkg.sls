{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

app-containers/containerd:
  pkg.installed:
    - reload_modules: true
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('app-containers/containerd') }}
      {% elif grains.os_family == 'Debian' %}
      - containerd
      {% endif %}
    - require:
      {{ libc.pkg_dep() }}
