{% import 'pkg/common' as pkg %}
pkg_bird:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/bird') }}
