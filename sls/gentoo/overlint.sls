overlint:
  pkg.latest:
    - pkgs:
      - app-portage/overlint: "~"
    - require:
      - portage_config: overlint
  portage_config.flags:
    - name: app-portage/overlint
    - accept_keywords:
      - ~*
