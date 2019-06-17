{% import 'pkg/common' as pkg %}
apcupsd_pkg:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('sys-power/apcupsd') }}
