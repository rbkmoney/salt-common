{% import 'pkg/common' as pkg %}
include:
  - lib.libc

net-mail/mailutils:
  pkg.latest:
    - require:
      - file: gentoo.portage.packages
      {{ libc_pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('net-mail/mailutils') }}



