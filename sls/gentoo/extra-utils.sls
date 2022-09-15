{% import 'pkg/common' as pkg with context %}
include:
  - gentoo.portage.packages

app-portage:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-portage/portage-utils') }}
      - {{ pkg.gen_atom('app-portage/gentoolkit') }}
      - {{ pkg.gen_atom('app-portage/genlop') }}

