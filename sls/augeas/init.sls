augeas:
  pkg.installed:
    - refresh: false
    - pkgs:
      - app-admin/augeas: "-=1.1.0"
      - dev-python/python-augeas: "~>=0.5.0"
