{% import 'pkg/common' as pkg %}
augeas:
  pkg.installed:
    - refresh: false
    - reload_modules: True
    - pkgs:
      - {{ pkg.gen_atom('app-admin/augeas') }}
      - {{ pkg.gen_atom('dev-python/python-augeas') }}
