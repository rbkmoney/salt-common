repoman:
  pkg.latest:
    - pkgs:
      - app-portage/repoman: "~"
    - require:
      - portage_config: repoman
  portage_config.flags:
    - name: app-portage/repoman
    - accept_keywords:
      - ~*
