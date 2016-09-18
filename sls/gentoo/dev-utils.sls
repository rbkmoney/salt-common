include:
  - gentoo.extra-utils

app-portage/repoman:
  pkg.latest:
    - pkgs:
      - sys-apps/portage: "~>=2.3.0"
      - app-portage/repoman: "~>=2.3.0"
    - require:
      - portage_config: app-portage/repoman
  portage_config.flags:
    - accept_keywords:
      - ~*

app-portage/overlint:
  pkg.latest

app-portage/gentoolkit-dev:
  pkg.latest
