{% import 'pkg/common' as pkg %}
sudo:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-admin/sudo') }}
