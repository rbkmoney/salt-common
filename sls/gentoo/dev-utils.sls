include:
  - gentoo.extra-utils

app-portage/repoman:
  pkg.latest:
    - pkgs:
      - dev-python/lxml: ">=3.6"
      - sys-apps/portage: ">=2.3"
      - app-portage/repoman: ">=2.3"

app-portage/overlint:
  pkg.latest

app-portage/gentoolkit-dev:
  pkg.purged
