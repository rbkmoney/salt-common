repoman:
  pkg.latest:
    - pkgs:
      - sys-apps/portage: "~>=2.3.0"
      - app-portage/repoman: "~>=2.3.0"
    - require:
      - portage_config: repoman
  portage_config.flags:
    - name: app-portage/repoman
    - accept_keywords:
      - ~*
