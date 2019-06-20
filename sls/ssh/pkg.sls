{% import 'pkg/common' as pkg %}
openssh:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/openssh') }}
