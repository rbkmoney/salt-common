{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

sys-apps/baselayout-java:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('sys-apps/baselayout-java') }}

dev-java/java-config:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-java/java-config') }}

app-eselect/eselect-java:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('app-eselect/eselect-java') }}
