{% import 'pkg/common' as pkg %}
pkg_bird:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/bird') }}
