{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - unbound.pkg

mail-filter/opendkim:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('mail-filter/opendkim') }}
    - require:
      - file: gentoo.portage.packages
      - pkg: net-dns/unbound      
