augeas:
  pkg.installed:
    - refresh: false
    - pkgs:
      - app-admin/augeas
      - dev-python/python-augeas
