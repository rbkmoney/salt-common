{% import 'pkg/common' as pkg with context %}
include:
  - gentoo.portage.packages
  - gentoo.extra-utils

dev-util/pkgcheck:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-util/pkgcheck') }}

dev-util/pkgdev:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-util/pkgdev') }}

app-portage/overlint:
  pkg.latest

app-portage/gentoolkit-dev:
  pkg.purged

app-portage/repoman:
  pkg.purged
