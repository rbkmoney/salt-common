{% import 'pkg/common' as pkg %}
terminus:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('media-fonts/terminus-font') }}
