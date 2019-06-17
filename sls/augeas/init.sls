augeas:
  pkg.installed:
    - refresh: false
    - pkgs:
      - {{ pkg.gen_atom('app-admin/augeas') }}
      - {{ pkg.gen_atom('dev-python/python-augeas') }}
