docker-pycreds:
  pkg.installed:
    - pkgs:
      - dev-python/docker-pycreds: "~>=0.2.1"
    - require:
      - portage_config: docker-pycreds
  portage_config.flags:
    - name: dev-python/docker-pycreds
    - accept_keywords:
      - "~*"
