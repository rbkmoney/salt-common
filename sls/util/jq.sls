{% import 'pkg/common' as pkg %}
app-misc/jq:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-misc/jq') }}
