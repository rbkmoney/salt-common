include:
  - gentoo.extra-utils

app-portage/repoman:
  pkg.latest:
    - pkgs:
      - dev-python/lxml
      - sys-apps/portage
      - app-portage/repoman

app-portage/overlint:
  pkg.latest

app-portage/gentoolkit-dev:
  pkg.purged
