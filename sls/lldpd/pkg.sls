{% import 'pkg/common' as pkg %}
include:
  - lib.glibc
  - gentoo.portage.packages
  - .selinux

net-misc/lldpd:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/lldpd') }}
