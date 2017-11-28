dev-python/django-tagging:
  pkg.latest:
    - require:
      - portage_config: dev-python/django-tagging
  portage_config.flags:
    - accept_keywords:
      - "~*"
