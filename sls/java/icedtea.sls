{% import 'pkg/common' as pkg %}
icedtea:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('dev-java/icedtea-bin') }}