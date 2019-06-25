{% import 'pkg/common' as pkg %}
openssh:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/openssh') }}
