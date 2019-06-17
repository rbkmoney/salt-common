pkg_bird:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/bird') }}
